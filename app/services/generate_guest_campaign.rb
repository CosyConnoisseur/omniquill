class GenerateGuestCampaign
  def self.call(guest_user)

    # heroku
    host_user = User.find(199)

    # for locally testing
    # host_user = User.find(10)

    # --- campaign card image/banner ---
    card_image_key = "4os3rejprxjhpjktuv3lno0w5ior"
    card_cloud_image = ActiveStorage::Blob.find_by(key: card_image_key)
    if card_cloud_image.nil?
      card_cloud_image = ActiveStorage::Blob.create!(
        key:          card_image_key,
        filename:     "sandbox_placeholder.gif",
        content_type: "image/webp",
        byte_size:    0,
        checksum:     "0"
      )
    end

    banner_image_key = "750ruin9i2ipdk9ujjod8185j8r4"
    banner_cloud_image = ActiveStorage::Blob.find_by(key: banner_image_key)
    if banner_cloud_image.nil?
      banner_cloud_image = ActiveStorage::Blob.create!(
        key:          banner_image_key,
        filename:     "sandbox_placeholder.jpg",
        content_type: "image/jpeg",
        byte_size:    0,
        checksum:     "0"
      )
    end


    # --- Welcome campaign ---
    @campaign = Campaign.create!(
      title: "Welcome to OmniQuill",
      synopsis: "Welcome and thank you for trying OmniQuill!\n
                This is an app that helps table-top players keep track of their long campaigns and stay focused on the actual playing!\n
                It features AI integrated character and session tracking. Go ahead and check it out!\n
                First, have a look at the Characters tab and maybe create a character!\n
                Please enjoy!",
      user: host_user,
    )
    @campaign.card_image.attach(card_cloud_image)
    @campaign.banner.attach(banner_cloud_image)
    @campaign.participations.create!(user: guest_user)

    # Given notes
    note = @campaign.notes.build(entry: "Notes are good for remembering things!")
    note.user = guest_user
    note.save

    note2 = @campaign.notes.build(entry: "Note to self: Check out the Chapters tab!")
    note2.user = guest_user
    note2.save

    # --- Chapters ---
    chapter1 = @campaign.chapters.build(title: "The Beginning...",
                                        summary: "4 new developers decide to build an entire app about helping table top players cut to the chase.\n
                                        The road was long and the difficulty was high but they knew they had what it took.\n
                                        Through ups and downs they persevered, sometimes staying up till 3am to get things finished!",
                                        highlights: "Shane developed the Character Creator. Nice transitions!, Jared did the art and handled chapters, Sammy did y, Ben did z",
                                        created_at:Time.zone.parse("August 1, 2026"),
                                        updated_at:Time.zone.parse("August 1, 2026"))
    chapter1.save

    chapter2 = @campaign.chapters.build(title: "The Release...",
                                        summary: "4 heroes release OmniQuill unto the world.\n
                                        With many lessons and skills developed, they were prepared for the world of software development.\n
                                        The journey continues...",
                                        highlights: "Shane designed the Campaign Page and AI integration. , Lots of things broke but were fixed in time. , Jared made this whole page! Chapters and Stickies , Sammy did y, Ben did z",
                                        created_at:Time.zone.parse("September 5, 2026"),
                                        updated_at:Time.zone.parse("September 5, 2026"))
    chapter2.save

    chapter3 = @campaign.chapters.build(title: "You Joined OmniQuill",
                                        summary: "This is probably the most important part of the entire journey!
                                        You have graced us with your presence and we are super grateful.\n
                                        Thank you once again for trying out OmniQuill!",
                                        highlights: "You tried the app, Everyone liked that, Today is better than yesterday",
                                        created_at: 1.minute.ago,
                                        updated_at: 1.minute.ago)
    chapter3.save

    # --- Stickies ---
    sticky1_1 = chapter1.stickies.build(text: "Let's do it!")
    sticky1_1.user_id = host_user.id
    sticky1_1.chapter_id = chapter1.id
    sticky1_1.save

    sticky1_2 = chapter1.stickies.build(text: "How about pixel art?")
    sticky1_2.user_id = host_user.id
    sticky1_2.chapter_id = chapter1.id
    sticky1_2.save

    sticky1_3 = chapter1.stickies.build(text: "This is tough...")
    sticky1_3.user_id = host_user.id
    sticky1_3.chapter_id = chapter1.id
    sticky1_3.save

    sticky1_4 = chapter1.stickies.build(text: "What's DnD?")
    sticky1_4.user_id = host_user.id
    sticky1_4.chapter_id = chapter1.id
    sticky1_4.save

    sticky2_1 = chapter2.stickies.build(text: "Finally done!")
    sticky2_1.user_id = host_user.id
    sticky2_1.chapter_id = chapter2.id
    sticky2_1.save

    sticky2_2 = chapter2.stickies.build(text: "It works!")
    sticky2_2.user_id = host_user.id
    sticky2_2.chapter_id = chapter2.id
    sticky2_2.save

    sticky2_4 = chapter2.stickies.build(text: "Just the beginning")
    sticky2_4.user_id = host_user.id
    sticky2_4.chapter_id = chapter2.id
    sticky2_4.save

    sticky3_1 = chapter3.stickies.build(text: "Thank you!")
    sticky3_1.user_id = host_user.id
    sticky3_1.chapter_id = chapter3.id
    sticky3_1.save

    sticky3_2 = chapter3.stickies.build(text: "Welcome!")
    sticky3_2.user_id = host_user.id
    sticky3_2.chapter_id = chapter3.id
    sticky3_2.save

    sticky3_3 = chapter3.stickies.build(text: "Maybe sign up... :D")
    sticky3_3.user_id = host_user.id
    sticky3_3.chapter_id = chapter3.id
    sticky3_3.save

    sticky3_4 = chapter3.stickies.build(text: "Nice recording")
    sticky3_4.user_id = host_user.id
    sticky3_4.chapter_id = chapter3.id
    sticky3_4.save



    #heroku
    p2_char = @campaign.participations.create!(user_id: 202) # Jared
    p3_char = @campaign.participations.create!(user_id: 201) # Sammy
    p4_char = @campaign.participations.create!(user_id: 200) # Ben
    p5_char = @campaign.participations.create!(user_id: 199) # Shane

    # for locally testing
    # p2_char = @campaign.participations.create!(user_id: 7) #
    # p3_char = @campaign.participations.create!(user_id: 8) #
    # p4_char = @campaign.participations.create!(user_id: 9) #
    # p5_char = @campaign.participations.create!(user_id: 10) #

    # --- character portraits ---
    p2_cloud_key = "om762q2qdvl7lkdp30pmhf78id7j" #
    p2_cloud_image = ActiveStorage::Blob.find_by(key: p2_cloud_key)

    if p2_cloud_image.nil?
      p2_cloud_image = ActiveStorage::Blob.create!(
        key:          p2_cloud_key,
        filename:     "sandbox_placeholder.jpg",
        content_type: "image/jpeg",
        byte_size:    0,
        checksum:     "0"
      )
    end

    p3_cloud_key = "yjrswrq5lei9hf0kur6lph9ujxup" #
    p3_cloud_image = ActiveStorage::Blob.find_by(key: p3_cloud_key)

    if p3_cloud_image.nil?
      p3_cloud_image = ActiveStorage::Blob.create!(
        key:          p3_cloud_key,
        filename:     "sandbox_placeholder.jpg",
        content_type: "image/jpeg",
        byte_size:    0,
        checksum:     "0"
      )
    end

    p4_cloud_key = "wye8g7l7gqpljgf4k91i6r4i4pop" #
    p4_cloud_image = ActiveStorage::Blob.find_by(key: p4_cloud_key)

    if p4_cloud_image.nil?
      p4_cloud_image = ActiveStorage::Blob.create!(
        key:          p4_cloud_key,
        filename:     "sandbox_placeholder.jpg",
        content_type: "image/jpeg",
        byte_size:    0,
        checksum:     "0"
      )
    end

    p5_cloud_key = "y5r9acggowuw9p3j4rtwa1cx3hiz" #
    p5_cloud_image = ActiveStorage::Blob.find_by(key: p5_cloud_key)

    if p5_cloud_image.nil?
      p5_cloud_image = ActiveStorage::Blob.create!(
        key:          p5_cloud_key,
        filename:     "sandbox_placeholder.jpg",
        content_type: "image/jpeg",
        byte_size:    0,
        checksum:     "0"
      )
    end

    # --- character sheets ---

    p2_cloud_sheet_key = "4blwbza0cte5euvarjh8ab4z38s1" #
    p2_cloud_sheet = ActiveStorage::Blob.find_by(key: p2_cloud_sheet_key)

    if p2_cloud_sheet.nil?
      p2_cloud_sheet = ActiveStorage::Blob.create!(
        key:          p2_cloud_sheet_key,
        filename:     "sandbox_placeholder.jpg",
        content_type: "image/jpeg",
        byte_size:    0,
        checksum:     "0"
      )
    end

    p3_cloud_sheet_key = "sk45ahek9gageo9imo7qppsa8gmk" #
    p3_cloud_sheet = ActiveStorage::Blob.find_by(key: p3_cloud_sheet_key)

    if p3_cloud_sheet.nil?
      p3_cloud_sheet = ActiveStorage::Blob.create!(
        key:          p3_cloud_sheet_key,
        filename:     "sandbox_placeholder.jpg",
        content_type: "image/jpeg",
        byte_size:    0,
        checksum:     "0"
      )
    end

    p4_cloud_sheet_key = "vzabasyp9qju72q86wg0c26i012d" #
    p4_cloud_sheet = ActiveStorage::Blob.find_by(key: p4_cloud_sheet_key)

    if p4_cloud_sheet.nil?
      p4_cloud_sheet = ActiveStorage::Blob.create!(
        key:          p4_cloud_sheet_key,
        filename:     "sandbox_placeholder.jpg",
        content_type: "image/jpeg",
        byte_size:    0,
        checksum:     "0"
      )
    end

    p5_cloud_sheet_key = "xgpskoh27khdlsoke7azajx1t0ry" #
    p5_cloud_sheet = ActiveStorage::Blob.find_by(key: p5_cloud_sheet_key)

    if p5_cloud_sheet.nil?
      p5_cloud_sheet = ActiveStorage::Blob.create!(
        key:          p5_cloud_sheet_key,
        filename:     "sandbox_placeholder.jpg",
        content_type: "image/jpeg",
        byte_size:    0,
        checksum:     "0"
      )
    end


    # --- characters and their images ---
    p2_character = Character.create!(
      name: "Jared", #
      stats_summary: "A meticulous and patient polyglot, Jared functions as a master of logic and architecture.
                      Drawing from his background in education and rhetoric, he approaches complex problems with the precision of a scholar.
                      Whether orchestrating classroom events or weaving intricate code for RPG systems, he excels at managing diverse variables under tight deadlines.
                      His mind is a library of languages, both spoken and digital, allowing him to bridge communication gaps seamlessly.
                      As a dedicated builder of virtual worlds and interactive systems, he is driven by a deep-seated need for structure,
                      efficiency, and thoroughness, ensuring that every project he undertakes is as functional as it is creative.", #
      participation: p2_char
    )
    p2_character.portrait.attach(p2_cloud_image)
    p2_character.document_upload.attach(p2_cloud_sheet)

    p3_character = Character.create!(
      name: "Sammy, the Speaker", #
      stats_summary: "hello I'm a stats summary about Sammy", #
      participation: p3_char
    )
    p3_character.portrait.attach(p3_cloud_image)
    p3_character.document_upload.attach(p3_cloud_sheet)

    p4_character = Character.create!(
      name: "Ben, the Recorder", #
      stats_summary: "hello I'm a stats summary about Ben", #
      participation: p4_char
    )
    p4_character.portrait.attach(p4_cloud_image)
    p4_character.document_upload.attach(p4_cloud_sheet)

    p5_character = Character.create!(
      name: "Shane", #
      stats_summary: "A master of systems and logic,
                      Shane Haddock possesses the analytical mind of a Philosopher combined with the technical prowess of an Artificer.
                      Deeply curious and highly adaptable, he excels at weaving complex code into functional, intuitive experiences.
                      His expertise lies in bridging the gap between abstract concepts and real-world application,
                      whether he is leading a team through a high-stakes development sprint or crafting immersive tools for TTRPG adventurers.
                      Patient and collaborative, he draws on his background in education to simplify the complex,
                      acting as both a supportive party member and a visionary architect. Dedicated to the constant pursuit of knowledge,
                      he is always integrating new technologies to refine his craft.", #
      participation: p5_char
    )
    p5_character.portrait.attach(p5_cloud_image)
    p5_character.document_upload.attach(p5_cloud_sheet)

  end
end
