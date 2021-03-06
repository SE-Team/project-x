require './lib/model/base'

class DataGenerator
	@event_res = 30
	@comment_res = 100

	@@users = [["superman",
				 "superman@super-hero.com",
				 "pass"],
				["batman",
				 "batman@super-hero.com",
				 "pass"],
				["spiderman",
				 "spiderman@super-hero.com",
				 "pass"],
				["joker",
				 "joker@super-hero.com",
				 "pass"],
				["venom",
				 "venom@super-hero.com",
				 "pass"],
				["bane",
				 "bane@super-hero.com",
				 "pass"],
				["lex_luther",
				 "lex_luther@super-hero.com",
				 "pass"],
				["lessie_ocon",
				 "lessie@test.com",
				 "pass"],
				["chere_lunde",
				 "chere@test.com",
				 "pass"],
				["virgilio_difiore",
				 "virgilio@test.com",
				 "pass"],
				["signe_frank",
				 "signe@test.com",
				 "pass"],
				["bryan_vigna",
				 "bryan@test.com",
				 "pass"],
				["majorie_osei",
				 "majorie@test.com",
				 "pass"],
				["carmine_cambell",
				 "carmine@test.com",
				 "pass"],
				["erik_claudio",
				 "erik@test.com",
				 "pass"],
				["reanna_brinegar",
				 "reanna@test.com",
				 "pass"],
				["charlena_swyers",
				 "charlena@test.com",
				 "pass"],
				["aundrea_konecny",
				 "aundrea@test.com",
				 "pass"],
				["yvette_ziegler",
				 "yvette@test.com",
				 "pass"],
				["debra_mccaw",
				 "debra@test.com",
				 "pass"],
				["livia_axel",
				 "livia@test.com",
				 "pass"],
				["eusebio_raiford",
				 "eusebio@test.com",
				 "pass"],
				["frederica_aaron",
				 "frederica@test.com",
				 "pass"],
				["jillian_starck",
				 "jillian@test.com",
				 "pass"],
				["eloy_crochet",
				 "eloy@test.com",
				 "pass"],
				["cindi_tobler",
				 "cindi@test.com",
				 "pass"],
				["joyce_days",
				 "joyce@test.com",
				 "pass"],
				["victoria_janas",
				 "victoria@test.com",
				 "pass"],
				["jaqueline_bruening",
				 "jaqueline@test.com",
				 "pass"],
				["nancey_kist",
				 "nancey@test.com",
				 "pass"],
				["alda_hodapp",
				 "alda@test.com",
				 "pass"],
				["vertie_alton",
				 "vertie@test.com",
				 "pass"],
				["shena_sautter",
				 "shena@test.com",
				 "pass"],
				["gerri_necaise",
				 "gerri@test.com",
				 "pass"],
				["ina_schlichting",
				 "ina@test.com",
				 "pass"],
				["vina_wayman",
				 "vina@test.com",
				 "pass"],
				["hung_robb",
				 "hung@test.com",
				 "pass"],
				["neil_massenburg",
				 "neil@test.com",
				 "pass"],
				["agripina_bloodsaw",
				 "agripina@test.com",
				 "pass"],
				["sharice_manney",
				 "sharice@test.com",
				 "pass"],
				["teena_wolcott",
				 "teena@test.com",
				 "pass"],
				["verda_boehme",
				 "verda@test.com",
				 "pass"],
				["jamar_jeppesen",
				 "jamar@test.com",
				 "pass"],
				["miriam_mongeau",
				 "miriam@test.com",
				 "pass"],
				["marianna_hasbrouck",
				 "marianna@test.com",
				 "pass"],
				["kiersten_sorber",
				 "kiersten@test.com",
				 "pass"],
				["eloise_dano",
				 "eloise@test.com",
				 "pass"],
				["weldon_tarleton",
				 "weldon@test.com",
				 "pass"],
				["ileen_grana",
				 "ileen@test.com",
				 "pass"],
				["lawana_mccune",
				 "lawana@test.com",
				 "pass"],
				["trevor_dix",
				 "trevor@test.com",
				 "pass"],
				["michelle_meagher",
				 "michelle@test.com",
				 "pass"],
				["newton_moriarty",
				 "newton@test.com",
				 "pass"],
				["cliff_fetty",
				 "cliff@test.com",
				 "pass"],
				["aleen_cintron",
				 "aleen@test.com",
				 "pass"],
				["cicely_walcott",
				 "cicely@test.com",
				 "pass"],
				["archie_mona",
				 "archie@test.com",
				 "pass"]
			]

	def rand_descriptions
		["Better Late Than Never",
		"Some raiders have arrived and enslaved a village. The PCs were none the wiser. The bad guys have now made good their escape, and the PCs have caught wind of it in time to chase them down before they make it back to their keep in the swamps",
		"Common Twists & Themes: The bad guys escaped by stealing a conveyance that the PCs know better than they do. The bad guys duck down a metaphorical (or literal) side-road, trying to hide or blend into an environment (often one hostile to the PCs).",
		"Any Old Port in a Storm",
		"The PCs are seeking shelter from marauding orcs, and come across a wayside temple to hole up in. They find that they have stumbled across something dangerous, secret, or supernatural, and must then deal with it in order to enjoy a little rest. The shelter contains the cause of the threat the PCs were trying to avoid.",
		"Better Late Than Never",
		"Some orcs have arrived and kidnapped the princess. The PCs were none the wiser. The bad guys have now made good their escape, and the PCs have caught wind of it in time to chase them down before they make it back to their tower in the mountains",
		"Common Twists & Themes: The bad guys escaped by stealing a conveyance that the PCs know better than they do. The bad guys duck down a metaphorical (or literal) side-road, trying to hide or blend into an environment (often one hostile to the PCs).",
		"Any Old Port in a Storm",
		"The PCs are seeking shelter from a hurricane, and come across a small cave to hole up in. They find that they have stumbled across something dangerous, secret, or supernatural, and must then deal with it in order to enjoy a little rest. The PCs must not only struggle for shelter, they must struggle to survive.",
		"Better Late Than Never",
		"Some raiders have arrived and stolen a holy idol from a local shrine. The PCs were none the wiser. The bad guys have now made good their escape, and the PCs have caught wind of it in time to chase them down before they make it back to their camp in the mountains",
		"Common Twists & Themes: The bad guys escaped by stealing a conveyance that the PCs know better than they do. The bad guys duck down a metaphorical (or literal) side-road, trying to hide or blend into an environment (often one hostile to the PCs).",
		"Any Old Port in a Storm",
		"The PCs are seeking shelter from a hurricane, and come across a small cave to hole up in. They find that they have stumbled across something dangerous, secret, or supernatural, and must then deal with it in order to enjoy a little rest. The shelter contains the cause of the threat the PCs were trying to avoid.",
		"Any Old Port in a Storm",
		"The PCs are seeking shelter from a thunder storm, and come across a abadoned ruin to hole up in. They find that they have stumbled across something dangerous, secret, or supernatural, and must then deal with it in order to enjoy a little rest. The place IS a legitimate shelter of some kind, but the PCs are not welcome, and must win hearts or minds to earn their bed for the night.",
		"Any Old Port in a Storm",
		"The PCs are seeking shelter from a sandstorm, and come across a abandoned castle to hole up in. They find that they have stumbled across something dangerous, secret, or supernatural, and must then deal with it in order to enjoy a little rest. The place IS a legitimate shelter of some kind, but the PCs are not welcome, and must win hearts or minds to earn their bed for the night.",
		"Better Late Than Never",
		"Some bandits have arrived and enslaved a village. The PCs were none the wiser. The bad guys have now made good their escape, and the PCs have caught wind of it in time to chase them down before they make it back to their tower in the swamps",
		"Common Twists & Themes: The bad guys escaped by stealing a conveyance that the PCs know better than they do. The bad guys duck down a metaphorical (or literal) side-road, trying to hide or blend into an environment (often one hostile to the PCs).",
		"Any Old Port in a Storm",
		"The PCs are seeking shelter from guards hunting for them, and come across a abadoned ruin to hole up in. They find that they have stumbled across something dangerous, secret, or supernatural, and must then deal with it in order to enjoy a little rest. The shelter contains the cause of the threat the PCs were trying to avoid.",
		"Clenell Spellbreaker the Judge (weak fat child human female, stooped back) asks party to slay Dragon, Song (Young).",
		"Dragon, Song (Young) is guarding double bed.",
		"Double bed needs to be given to Spider, Subterranean (Sword Spider).",
		"Giant tree in Brilliant Forest which shows directions to hills.",
		"Hills which shows directions to creek in the Tangle of Radifora.",
		"Chair with straps needs to be returned to haunted dungeon in swamp.",
		"Haunted dungeon in swamp where party can find Londoreld the Squire (annoyed tall teen half-elven male, strong body odor).",
		"Londoreld the Squire (annoyed tall teen half-elven male, strong body odor) sends party to talk to Orur Stronggrim the Old-clothes seller (depressed adult halfling male, curious).",
		"Kardar the Clergy (disregarded teen half-orc male, coonformist) sends party to talk to Haenwyth Notooth the Warlock (cruel fat teen human female, stutters).",
		"Haenwyth Notooth the Warlock (cruel fat teen human female, stutters) sends party to talk to Lyrwethen the Bard (fearful adult drow elf female, cruel).",
		"Lyrwethen the Bard (fearful adult drow elf female, cruel) sends party to talk to Ammir Grimleg the Ruler (playful adult human male, capricious).",
		"Pwenna the Ranger (offended adult dwarven female, nearsighted) asks party to slay Xorn, Average.",
		"Xorn, Average has kidnapped Athstaff Spotcheek the Lady (hopeless tall child human male, capricious).",
		"Athstaff Spotcheek the Lady (hopeless tall child human male, capricious) asks party to slay Manticore.",
		"Telath the Actor (evasive muscular child dwarven male, particularly high voice) sends party to talk to Conthar Spellwalker the Locksmith (playful short adult human male, suspicious)",
		"Abandoned cave in Bleak Copse is the resting place of light catapult.",
		"Light catapult must be brought to Ithill Stoutmeadow the Painter (worried adult halfling female, particularly high voice).",
		"Ithill Stoutmeadow the Painter (worried adult halfling female, particularly high voice) sends party to cave in Pale Willows.",
		"Ornamental carriage shows directions to wooden armchair.",
		"Wooden armchair needs to be used on gaff/hook, held."]
	end

	def tags
		["work",
		 "entertainment",
		 "personal",
		 "school",
		 "outdoor",
		 "etc"]
	end

	def ipsum_comments
		["Nulla eros justo, feugiat id pellentesque at, scelerisque eget quam. Proin viverra lacus id nisl feugiat eget consequat neque consequat. Praesent elementum odio a dui blandit ac sollicitudin turpis mollis. Sed vel ipsum sit amet nulla imperdiet tristique in quis lectus. Integer.",
		 "Maecenas dui augue, interdum ac lobortis id, aliquam vitae lectus. Cras bibendum condimentum orci in commodo. Integer at nulla in quam congue pulvinar et ac diam. Proin placerat, lectus tempor sagittis mollis, urna risus convallis erat, non elementum diam mauris sed lectus.",
		 "Morbi id justo eget magna congue viverra. Integer turpis velit, vehicula a mollis at, tempor quis nisi. Integer interdum placerat risus, et convallis est ullamcorper quis. Nullam nec lacus nec mi bibendum scelerisque et sodales tortor. Aliquam risus erat, commodo scelerisque rutrum.",
		 "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ut nulla dui, in luctus risus. Cras quis erat eget odio aliquam facilisis.",
		 "Praesent neque magna, pharetra ut condimentum sit amet, rhoncus vitae urna. Phasellus eleifend tellus vitae augue vehicula nec pellentesque ",
		 "purus tempor. Donec cursus magna in diam lacinia eget semper enim porttitor. Nulla facilisi. Vestibulum adipiscing sagittis sagittis. Quisque",
		 "sollicitudin interdum nibh eget euismod. Pellentesque at purus id dui dignissim varius non sit amet orci. Nulla facilisi. Fusce lobortis, est",
		 "eu ultricies molestie, urna arcu feugiat quam, eget facilisis tortor massa consectetur elit. Aenean vitae lorem nec felis porttitor egestas sed ac odio.",
		 "Nunc luctus, est ac tincidunt ullamcorper, massa mi posuere erat, vitae scelerisque purus erat a nunc. Curabitur eu aliquet augue. Pellentesque tempor",
		 "enim tellus, condimentum vehicula ipsum. Ut sed faucibus lectus. Duis fermentum tellus ac quam tincidunt quis condimentum quam mollis.",
		 "Phasellus in orci sem, ac porta urna. Aliquam vehicula leo at turpis dignissim nec dignissim turpis sodales. Curabitur vitae",
		 "felis id erat rutrum mollis. Duis non ante semper eros porta blandit.",
		 "Sed ut enim volutpat nulla sagittis feugiat eu ac",
		 "sapien. Donec condimentum neque a mauris mattis auctor. Ut imperdiet purus vitae ligula pulvinar commodo.",
		 "Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed non magna nisl, ut dapibus ",
		 "est. Pellentesque id nisi nisl. Donec sed diam sit amet purus placerat molestie. Curabitur nibh ligula, dictum sed suscipit",
		 "eu, mollis quis nibh. Duis elit nulla, pretium tempus mattis ut, porta sit amet nulla. Nullam dignissim magna vitae odio",
		 "molestie et interdum dui sodales. Morbi tristique lobortis nisi, eu lacinia mi dapibus luctus. Nam eget mauris velit.",
		 "Aenean facilisis ultricies quam suscipit pretium. Aliquam eleifend diam eget ipsum dignissim in porttitor lectus dignissim. Nam vitae libero ut mauris blandit aliquam. Donec",
		 "lacinia tempor magna, id bibendum orci aliquam sit amet. Quisque tincidunt dignissim metus sit amet euismod. Aliquam placerat tempor ",
		 "euismod. Donec eget nunc id libero vehicula interdum in eu diam. Nulla ut arcu nec ante tincidunt varius. Pellentesque id",
		 "nisl vitae augue vulputate eleifend in et ipsum. Aenean placerat bibendum adipiscing. Phasellus dictum volutpat diam sit amet interdum. Maecenas porttitor,",
		 "augue sed mollis porta, velit tortor ultrices libero, sed ornare purus urna quis leo. Mauris viverra sapien vitae augue varius ultrices. Aenean malesuada nibh vitae odio tempus quis vestibulum nibh varius. ",
		 "Phasellus tincidunt vulputate hendrerit. Donec vestibulum nunc et augue rhoncus eget sagittis est lacinia.",
		 "Proin nec diam sed odio vulputate egestas ac eu odio. Nulla at risus turpis. Nulla semper fermentum nibh vitae pellentesque. Maecenas facilisis massa lacinia",
		 "sapien tempor dapibus. Vivamus magna orci, luctus a condimentum et, luctus ac est. Aliquam erat volutpat. Proin ",
		 "nec malesuada tellus. Nulla porta aliquam enim, nec dapibus nunc sollicitudin porta. Proin non nunc vel orci vulputate ornare.",
		 "Nullam hendrerit blandit nibh at pellentesque. Curabitur euismod dapibus eleifend.",
		 "Alo aliquam vestibulum fringilla. Donec sollicitudin erat nec erat tincidunt",
		 "a sodales lorem pharetra. Quisque blandit vestibulum sem ac mattis. Praesent ut elit quis",
		 "arcu fringilla suscipit sit amet ac metus. In hac habitasse platea dictumst. Donec porttitor consectetur volutpat. Ut aliquam suscipit ",
		 "hendrerit. Nunc sollicitudin mattis arcu et mattis. Duis ac rutrum eros.",
		 "Cras semper viverra magna ac ornare.",
		 "Aenean fermentum urna nisl, a elementum ipsum. Morbi sit amet varius leo. Suspendisse in nisl sed ante",
		 "adipiscing faucibus sed",
		 "ut turpis. Morbi id elit in mi tempus vulputate ut id dui. Pellentesque quis augue ligula, ",
		 "nec consectetur lectus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;",
		 "Fusce turpis augue",
		 "euismod sed malesuada et, iaculis sed risus. Sed sit amet tortor ut felis lobortis commodo eu eget libero. Etiam euismod",
		 "ondimentum ullamcorper. Aenean viverra faucibus tellus sit amet feugiat. Nunc varius volutpat magna a imperdiet. Vestibulum nec lorem ut ",
		 "augue porta ullamcorper. Mauris mollis nunc in ipsum dignissim ut laoreet enim mollis. Lorem ipsum dolor sit amet, consectetur adipiscing",
		 "elit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Maecenas vel nisl eget erat accumsan vestibulum et ac",
		 "neque. Ut non velit eu odio bibendum commodo. Ut vel ultricies leo. Suspendisse vitae mi nunc.",
		 "Suspendisse quam purus, porta sit amet pellentesque nec, rutrum eu risus. Praesent varius ipsum a diam elementum tristique. Donec eu elit orci, suscipit facilisis nunc. ",
		 "Curabitur a leo id nibh elementum dictum eu sed est. Vivamus felis purus, molestie vitae bibendum non, bibendum nec ante. Praesent tincidunt hendrerit aliquet. Nulla ac risus nunc. ",
		 "Etiam aliquet laoreet tincidunt. Curabitur eget neque lacus, nec luctus sem. Nulla facilisi. Cras consectetur, massa ut molestie vestibulum, turpis tortor hendrerit dui, quis vehicula elit ante non diam. ",
		 "Thing felis sem, adipiscing eleifend blandit eget, tempor sit amet eros. Suspendisse quis tellus sit amet lacus viverra rhoncus quis vel risus. Etiam semper tempor mauris eu volutpat. Integer a tempor metus. Nunc ac dolor in arcu ultricies feugiat."]
	end

	def titles
		["Gonriel",
		"Donthyryr",
		"Elrond",
		"Angard",
		"Nazduin",
		"Beleggroth",
		"Baradduin",
		"Arost",
		"Beleggorn",
		"Beleggroth",
		"Wardervalley",
		"Cold Woodland",
		"Prince Court",
		"Courtchapel",
		"Catwilds",
		"Winter Town",
		"Wildcatwilds",
		"Spiderhills",
		"Goblinwaste",
		"Bottle Barren",
		"Barrelrange",
		"Kingsnock",
		"Alder bay",
		"Fairmarsh",
		"Bouldercataract",
		"Guildmead",
		"Orc county",
		"Narrow keep",
		"Dank harbor",
		"Smallpool",
		"Galadthyryr",
		"Dongroth",
		"Belgorn",
		"Oroddor",
		"Belruin",
		"Loththyryr",
		"Amonthyryr",
		"Morcirith",
		"Angorn",
		"Orodadan"]
	end

	def rand_users
		puts "Generate random users"
		users = @@users
		users.each do |user|
			print "."
			new_user = User.first_or_create(user_name: user[0], email: user[1], password: user[2])
			new_user.save
		end
		puts "."
	end

	def rand_events(max_events=25)
		puts "Generate random events"
		descriptions = rand_descriptions
		users = User.all[(0..User.all.count)]
		users.each do |user|
			print "."
			(1..(1 + rand(max_events))).each do |i|
				categories = ["outdoor",
											"personal",
											"music",
											"tv",
											"movies",
											"entertainment",
											"art",
											"community",
											"etc",
											"school",
											"sports",
											"political",
											"charity"]
				rand_category = categories[rand(categories.size)]
				title_seed = rand(titles.count)
				description_seed = rand(descriptions.count)
				new_event = Event.create(title: titles[title_seed], body: descriptions[description_seed], user: user, img_url: "/images/banksy/thumb/#{(1 + rand(19))}.jpg", start_date: DateTime.now, end_date: DateTime.now.next_day)
				category = Category.create(event: new_event)
				new_event.category.name = rand_category
				new_event.save
			end
		end
		puts "."
	end

	def rand_comments(max_comments=5)
		puts "Generate random comments"
		comments = ipsum_comments
		Event.all.each	do |event|
			print "."
			(1..(rand(max_comments))).each do |i|
				comment_seed = rand(comments.count)
				rand_user = User.first(id: (1 + rand(User.all.count)))
				Comment.create(tumbler: event.tumbler, posted_by: rand_user.user_name, email: rand_user.email, body: comments[comment_seed])
			end
		end
		puts "."
	end

	def rand_messages(max_msg_per_user=10)
		puts "Generate random private message between users."
		comments = ipsum_comments
		descriptions = rand_descriptions
		User.all.each do |u|
			print "."
			(1..(rand(max_msg_per_user))).each do |i|
				title_seed = rand(titles.count)
				description_seed = rand(descriptions.count)
				comment_seed = rand(comments.count)
				rand_user = User.first(id: (1 + rand(User.all.count)))
				msg = SMessage.create(user: u, subject: titles[title_seed], body: descriptions[description_seed])
				msg.send(rand_user)
			end
		end
		puts "."
	end

	def rand_followships(max_followers_per_user=5)
		puts "Generate random followships between users."
		User.all.each do |u|
			print "."
			(0..max_followers_per_user).each do |i|
				u.follow(User[i])
			end
		end
		puts "."
	end

end

