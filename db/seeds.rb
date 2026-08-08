# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Character.destroy_all
Participation.destroy_all
Campaign.destroy_all
User.destroy_all
Chapter.destroy_all
Note.destroy_all


puts "Populating users..."

ani = User.create!(
  email: "aniwhistler@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  username: "ani"
)

johno = User.create!(
  email: "jhony36@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  username: "johno37"
)

waifulover = User.create!(
  email: "bill-flozner@hotmail.com",
  password: "123456",
  password_confirmation: "123456",
  username: "waifulover420"
)

ra_stein = User.create!(
  email: "ra_stein@yahoo.jp",
  password: "123456",
  password_confirmation: "123456",
  username: "goblinpounder44"
)

player1 = User.create!(
  username: "Player 1",
  email: "p1@example.com",
  password: "password123",
  password_confirmation: "password123"
)

puts "...finished populating users"


puts "Populating campaigns..."

labyrinth = Campaign.create!(
  title: "The great labyrinth",
  setting: "Medieval magic fantasy. Set underground.",
  synopsis: "Deep beneath the fractured kingdoms of Aethelgard lies the Undercrypt—a sprawling,
  ever-shifting subterranean labyrinth forged by dead gods and ancient,
  volatile magic. When a sudden eclipse unleashes a shadow plague that consumes the surface world,
  an unlikely trio—a disgraced spell-thief, a guilt-ridden paladin, and a scholar who speaks the ruin-tongue
  is forced into a desperate descent. Together, they must navigate lightless abysses, deadly arcane traps,
  and warring subterranean civilizations to reach the maze's heart, where a forgotten engine of primordial light slumbers.
  Yet in a realm that feeds on secrets and actively warps reality, the greatest threat isn't the horrors lurking in the dark,
  but the horrifying truth of why the world above was cursed in the first place.",
  user: player1
)
puts "Populating campaigns 1 done"

diamond_lake = Campaign.create!(
  title: "Death and Determination at Camp Diamond Lake",
  setting: "Modern day where monsters and cryptids exist. In a summer camp site surrounded by woods.",
  synopsis: "Welcome to Camp Echo Lake, a seemingly ordinary summer getaway where the 'wildlife' includes
  caffeinated Sasquatches, passive-aggressive Jackalopes, and a Mothman who refuses to leave the campfire light.
  When a horde of mischief-making gnomes swipes the camp director's prized golf cart—and the emergency smores
  stash it's up to your ragtag team of counselors to venture into the deep, weird woods and get them back.
  Armed with rusty canoe paddles, improvised spell-casting through cafeteria snacks, and a whole lot of bad decisions,
  you'll have to outsmart suburban cryptids to survive.
  Just remember to roll for initiative whenever you hear rustling in the snack shack!",
  user: ani
)

puts "...finished populating campaigns"


puts "Populating chapters..."

depths = Chapter.create!(
  title: "Into the depths...",
  summary: "Driven beneath the ruined kingdoms of Aethelgard to escape the consuming shadow plague, the unlikely
  trio plunged into the lightless abyss of the Undercrypt. Guarded by the fierce blade of the disgraced fighter
  Sefia Rhynberg, the party navigated the labyrinth's treacherous, shifting stone while Vairna's soft luminescence
  provided their only defense against the suffocating dark. As ancient arcane traps sprang to life around them,
  Hagen Kellsmush wove tales of forgotten primordial light to steady their fraying nerves, keeping their spirits
  intact as the realm itself began to bend reality around their every step. Yet with every mile descended into the
  subterranean maze, the ominous whispers of the deep made one thing terrifyingly clear: the secrets buried in these
  depths were far darker than the curse they had left behind.",
  highlights: "Hagen Kellsmush remembered he knew about primordial light, Vairna's light discovered a suspicious rock",
  campaign: labyrinth
)

traps = Chapter.create!(
  title: "Paranoid over traps",
  summary: "Still reeling from their initial descent into the Undercrypt, the fragile alliance was tested as the
  labyrinth's volatile magic began actively warping the stone around them into a gauntlet of hair-trigger arcana.
  Sefia Rhynberg took the lead with a cautious blade, testing every shadow and shifting tile, while Vairna hovered
  close, her delicate mending light ready to soothe the minor burns and scrapes of their novice blunders. Hagen
  Kellsmush kept the suffocating dread at bay, using his booming half-orc cadence to turn their near-misses with
  ancient pressure plates into rhythmic, grounding chants. Though the trio managed to creep through the shifting
  corridor without triggering a fatal collapse, the creeping suspicion took root that the dungeon was actively
  watching—and tailoring its cruelty just for them.",
  highlights: "Sefia triggered a trap volentarily 'just to see what it would do', Hagen couldn't stop chanting to keep his nerves.",
  campaign: labyrinth
)

feelers = Chapter.create!(
  title: "The Depth Feelers fight",
  summary: "The oppressive paranoia of the trap-laden halls gave way to raw terror when writhing, blind monstrosities
  erupted from the slick cavern walls to stalk the weary party. Sefia Rhynberg threw herself into the breach,
  her blade clashing desperately against slick, grasping tendrils while Vairna darted through the gloom to weave
  glowing fairy magic over the fighter's growing wounds. Rallying his battered allies, Hagen Kellsmush bellowed a
  fierce half-orc battle song that echoed through the stone, granting them the desperate surge of courage needed to
  drive their weapons deep into the creatures' hearts. Though victorious and breathing heavily amidst the slain horrors,
  the bloody stench left behind served as a grim reminder that every struggle in the Undercrypt only invites greater
  shadows to gather.",
  highlights: "Three critical misses for Vairna in a row!, Hagen got knocked out, Sefia delt the finishing blow!",
  campaign: labyrinth
)

hunt = Chapter.create!(
  title: "Readying to hunt",
  summary: "The peaceful evening at Camp Echo Lake shattered when a rogue gang of gnomes staged a midnight heist,
  making off with both the camp director's prized golf cart and the apocalyptic-level emergency s'mores supply.
  Refusing to let summer be ruined on night one, Squilliam Fancyson, Howard Lavender, and the towering crab-cryptid
  Blug rallied their fledgling, level-one wits in the flickering glow of the fire pit. Armed with little more than
  rusty canoe paddles, weaponized cafeteria snacks, and questionable life choices, the trio braced themselves against
  the eerie judgment of a nearby Mothman as they prepared to march into the weird, dark woods. The hunt was officially
  on, but as whispers rustled from the direction of the snack shack, the counselors quickly realized the forest's
  suburban cryptids were already waiting for them.",
  highlights: "Blug got many hugs!, The gnomes were very squishy for Blug, Squilliam hoped he might be related to Blug",
  campaign: diamond_lake
)

puts "...finished populating chapters"


puts "Populating participations..."

invite1 = Participation.create!(user:johno, campaign:labyrinth)
invite2 = Participation.create!(user:player1, campaign:labyrinth)
invite3 = Participation.create!(user:waifulover, campaign:labyrinth)

invite4 = Participation.create!(user:player1, campaign:diamond_lake)
invite5 = Participation.create!(user:ra_stein, campaign:diamond_lake)
invite6 = Participation.create!(user:johno, campaign:diamond_lake)

puts "...finished populating participations"


puts "Populating characters..."

Character.create!(
  name: "Sefia Rhynberg",
  stats_summary: "While her family's financial situation wasn't the best, her new parents
  were always there for her. She was determined to pay them back for it as soon as she could.
  She knew she still wasn't the smartest around, and being poor without access to many
  teaching materials meant she needed to do something else. So, at the age of 2,
  she started training. She couldn't remember what routines or workouts were optimal for
  what she needed, but she figured if she did enough push ups and squats that it would
  eventually lead to results. She was 7 when she joined a small mercenary band.
  She heard about one going through her village, went to the leader and convinced him to
  let her join. It helped that she managed to win arm wrestling contests against all
  the other members. All but the leader. At first, they only used her as a mule, but the
  leader decided to give her a chance after he realized she could carry almost all of their
  equipment for miles without breaking much of a sweat. She quickly figured out,
  after using a dagger for a year, that it was difficult to reach her targets because of her
  small stature. So using a long pointy stick would probably be better. And better it was.
  Once she was 12, she managed to go off on her own and earn contracts herself.
  She would send whatever extra money she made to her parents. Everything was going pretty
  good for about a year, until her mother started becoming ill. The sudden demand in money
  made her have to take on more high profile work. Some she wished she didn't have to do.
  Days turns into weeks, weeks into months. Still, her mom wasn't getting better. While
  fulfilling her contracts, she looked for ways/people that could help her mother. A few
  expensive doctors came and went. Still nothing, but now debt followed her everywhere.
  This continued for a few years until she became 17. She is now determined to go into the
  labyrinth to make some money for her parents.",
  participation: invite1
)

Character.create!(
  name: "Vairna",
  stats_summary: "She's always been extremely curious, even as a child. She went through
  the regular teachings that Light Fairies go through with their parents in her village,
  Lissle . She soon left her community afterwards to explore the world. She encountered
  humans pretty quickly and tried to learn more about them. She quickly learned the
  language and has been through a couple of small villages. She's never stayed for longer
  than a few weeks though. While she's still curious about humans, she's recently been
  interested in magical artifacts and other magics in general. She's been trying to create
  her own for a while now and only recently she's heard about Saux. As a result, she's been
  looking to maybe study/make one of her own. She's never been to a city before because it
  was intimidating and most human guards wouldn't let her enter. As a result, she decided
  to wait for her opportunity to get in, which came once the lbayrinth appeared. She's now
  joining the others in the descent.",
  participation: invite2
)

Character.create!(
  name: "Hagen Kellsmush",
  stats_summary: "A travelling bard that visits a lot of places; could almost be considered
  an adventurer. Originaly from Nevard, he's apparently been travelling for a long time now,
  honing his craft with various types of stringed-instruments. He's mostly self-taught
  when it comes to his magic and instruments; however he did go to regular school until he
  was 13. After that, he started trying to explore around his city a lot, until finally he
  left for Chauria to try and learn the basics of his instruments and a few songs. He only
  stayed in Chauria for 2 years until he couldn't stand staying anymore and promptly left,
  taking his studies to the road. He met plenty of people on his travels that could teach
  him new songs, tell him about new instruments, and generally helpful people. He eventually
  landed in Demos where he learned various sea shanties and went out to sea for some time.
  He came back to Ozoris after 4 years in and out of the sea.",
  participation: invite3
)

squilliam = Character.create!(
  name: "Squilliam Fancyson",
  stats_summary: "Squilliam Fancyson is Squidward Tentacles' high school arch-rival.
  Squilliam attended Squidward's band class, and always puts him down.
  He is a very wealthy, snooty rival of Squidward who looks down at Squidward,
  for being just a lowly cashier in a greasy spoon.",
  participation: invite4
)

squilliam.portrait.attach(
  io: File.open(Rails.root.join("app/assets/images/squilliam.png")),
  filename: "squilliam.png",
  content_type: "image/png"
)

Character.create!(
  name: "Howard Lavender",
  stats_summary: "Howard was born a stupid child, he mistook every one as his mother and got
  accidentally kidnapped on multiple occasions due to it, and so his parents named him Howard,
  because he showed no talents. At the age of 4, they sold him to a group of sketchy
  scientists for a few dollars. They used him as an assistant, to hold treys,
  fetch equipment, and tend to the animals, he was happy. But then one day he found a
  strange black thick liquid and consumed it without thinking, when he awoke, he was
  suddenly smart. His road was not easy, he struggled to control his new form and cope
  with his new found intelligence. He became inspired to study as a healer and hide his
  demon, despite it rarely talking to him in his sleep and through reflections very faintly,
  and never seeming to be clear. Howard is in constant debate between loving his gift or
  hating the curse that came with it.",
  participation: invite5
)

Character.create!(
  name: "Blug",
  stats_summary: "Born a cryptid himself, he's a 7 foot tall crab monstrosity that has two giant
  pincers for hands. He isn't the brightness crayon in the pack, but he has a big heart.
  all he wants to do is love and be loved. He is quite strong, too. It's strange, because
  whenever he goes in for a hug, the recipiant always ends up bleeding a lot, and he hears
  a lot of bones cracking, but everyone does this, so it's nothing strange. Whenever his friends
  stop moving from one of his hugs, he decided to hang them on his giant shell on his back.
  Since they can't move, he has to protect them somehow.",
  participation: invite6
)

puts "...finished populating characters"


puts "Populating notes..."

Note.create!(
  user: johno,
  entry: "Watch out for Vairna, she seems sus. Never trust a fairy.",
  campaign: labyrinth
)

puts "Populating notes 1 done"

Note.create!(
  user: ra_stein,
  entry: "Maybe if I study Blug, I might know a bit more about my own
  condition. He's monstrous, so that counts.",
  campaign: diamond_lake
)

puts "...finished populating notes"


puts "Populating stickies..."

Sticky.create!(
  text: "Definite party wipe",
  user: johno,
  chapter: depths
)

Sticky.create!(
  text: "Scary!",
  user: waifulover,
  chapter: depths
)

Sticky.create!(
  text: "Big bonks...",
  user: player1,
  chapter: feelers
)

Sticky.create!(
  text: "Cryptids assemble!",
  user: waifulover,
  chapter: hunt
)

Sticky.create!(
  text: "Murder time 😈",
  user: johno,
  chapter: hunt
)

puts "...finished populating stickies"
