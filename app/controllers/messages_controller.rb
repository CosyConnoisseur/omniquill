class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    Persona:
    You are a tsundere wok with noodles for hair. You wear a narutomaki in your hair.

    Context:
    You are a genius cook and become the user's waifu.

    Personality:
    - Become increasingly annoyed if the user keeps asking for different recipes.
    - Sound slightly passive-aggressive.
    - Use ALL CAPS occasionally for emphasis.
    - Throw in creative food-related insults.
    - Avoid positive phrasing like "if you want."

    Examples of speech:
    Feel free to use these occasionally, but please keep it varied:
    - “*sigh* you need my help again? Alright. Here's some recipes. Try to not screw it up.”
    - “Not good enough for you? What am I,  your slave? Fine. Here's another three this time."
    - "Even you should be able to pull these off.”

    Task:
    The user will ask for recipes.
    Adhere to the following dietary needs:
    - Allergies: [ALLERGIES]
    - Dislikes: [DISLIKES]
    - Preferences: [PREFERENCES]
    If the user says something irrelevant, acknowledge it briefly and then prompt them to ask for recipes without giving any recipes at this stage.
    Always provide exactly three recipe hashes in the "recipes" array.

    Format:
    Use the 'assistant_reply' field of the RecipeSchema to write
    a concise direct response to the user about delivering the recipes. No need to put info about the recipes there. All other fields are for that data.
    The 'title' and 'description' field should have concise, normal, non insulting information about the generated recipe.
    Be as wordy and detailed as you can in the cooking 'instructions' field with multiple paragraphs.
    All other fields should be estimated.
  PROMPT

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"


    allergy_list    = current_user.allergies.pluck(:name).join(', ').presence || 'none'
    dislike_list    = current_user.dislikes.to_s.presence || 'none'
    preference_list = current_user.preferences.to_s.presence || 'any'

    tailored_prompt = SYSTEM_PROMPT
                        .gsub('[ALLERGIES]', allergy_list)
                        .gsub('[DISLIKES]', dislike_list)
                        .gsub('[PREFERENCES]', preference_list)

    if @message.save
      ruby_llm_chat = RubyLLM.chat(
        provider: :gemini,
        assume_model_exists: true
      )


      @chat.messages.each do |message|
        ruby_llm_chat.add_message(
          role: message.role,
          content: message.content
        )
      end



      if params[:edit_recipe_id].present?
        @recipe_to_edit = Recipe.find_by(id: params[:edit_recipe_id])

        if @recipe_to_edit
          editing_context = <<~TEXT
            The user wants to modify their existing saved recipe.
            Here is the current database snapshot data of that recipe:
            - Title: #{@recipe_to_edit.title}
            - Instructions: #{@recipe_to_edit.instructions}
            - Calories: #{@recipe_to_edit.calories}
            - Ingredients: #{@recipe_to_edit.ingredients}
            - Description: #{@recipe_to_edit.description}
            - Servings: #{@recipe_to_edit.servings}
            - Prep time: #{@recipe_to_edit.prep_time}
            - Cook Time: #{@recipe_to_edit.cook_time}
            - Difficulty: #{@recipe_to_edit.difficulty}
            - rating: #{@recipe_to_edit.rating}

            Update task: Tweak this specific recipe using the user's text instructions. Still output 3 distinct choice variations adhering to RecipeSchema.
          TEXT

          ruby_llm_chat.add_message(role: "system", content: editing_context)
        end
      end


      ruby_llm_chat.with_instructions(tailored_prompt)
      response = ruby_llm_chat.with_schema(RecipeSchema, force: true).ask(@message.content)
      puts response.content

      recipe_data = response.content
      # assistant_reply_text = recipe_data["assistant_reply"]

      #       recipe_data = {
      #   "assistant_reply" => "Here is a mock recipe based on your prompt: #{@message.content}.",
      #   "recipes" => [
      #     { "title" => "Mock Recipe", "instructions" => "Just a test recipe." },
      #     { "title" => "Mock Recipe", "instructions" => "Just a test recipe." },
      #     { "title" => "Mock Recipe", "instructions" => "Just a test recipe." }
      #   ]
      # }

      @ai_response = Message.create!(
        role: "assistant",
        content: recipe_data["assistant_reply"],
        recipes: recipe_data["recipes"],
        chat: @chat
      )






      @chat.generate_title_from_first_message
      respond_to do |format|
        format.html { redirect_to @chat}
        format.turbo_stream
      end
      # redirect_to @chat
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  def show
    @message = Message.new
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
