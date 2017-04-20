import Ember from 'ember';

const {
  Service,
  computed,
  getProperties,
  String: { htmlSafe },
} = Ember;

const emojiSet = [
  [0, 0, 0, ":smile:"],
  [0, 0, 1, ":smiley:"],
  [0, 0, 2, ":grinning:"],
  [0, 0, 3, ":blush:"],
  [0, 0, 4, ":relaxed:"],
  [0, 0, 5, ":wink:"],
  [0, 0, 6, ":heart_eyes:"],
  [0, 0, 7, ":kissing_heart:"],
  [0, 0, 8, ":kissing_closed_eyes:"],
  [0, 0, 9, ":kissing:"],
  [0, 0, 10, ":kissing_smiling_eyes:"],
  [0, 0, 11, ":stuck_out_tongue_winking_eye:"],
  [0, 0, 12, ":stuck_out_tongue_closed_eyes:"],
  [0, 0, 13, ":stuck_out_tongue:"],
  [0, 0, 14, ":flushed:"],
  [0, 0, 15, ":grin:"],
  [0, 0, 16, ":pensive:"],
  [0, 0, 17, ":relieved:"],
  [0, 0, 18, ":unamused:"],
  [0, 0, 19, ":disappointed:"],
  [0, 0, 20, ":persevere:"],
  [0, 0, 21, ":cry:"],
  [0, 0, 22, ":joy:"],
  [0, 0, 23, ":sob:"],
  [0, 0, 24, ":sleepy:"],
  [0, 0, 25, ":disappointed_relieved:"],
  [0, 0, 26, ":cold_sweat:"],
  [0, 1, 0, ":sweat_smile:"],
  [0, 1, 1, ":sweat:"],
  [0, 1, 2, ":weary:"],
  [0, 1, 3, ":tired_face:"],
  [0, 1, 4, ":fearful:"],
  [0, 1, 5, ":scream:"],
  [0, 1, 6, ":angry:"],
  [0, 1, 7, ":rage:"],
  [0, 1, 8, ":triumph:"],
  [0, 1, 9, ":confounded:"],
  [0, 1, 10, ":satisfied:"],
  [0, 1, 11, ":yum:"],
  [0, 1, 12, ":mask:"],
  [0, 1, 13, ":sunglasses:"],
  [0, 1, 14, ":sleeping:"],
  [0, 1, 15, ":dizzy_face:"],
  [0, 1, 16, ":astonished:"],
  [0, 1, 17, ":worried:"],
  [0, 1, 18, ":frowning:"],
  [0, 1, 19, ":anguished:"],
  [0, 1, 20, ":smiling_imp:"],
  [0, 1, 21, ":imp:"],
  [0, 1, 22, ":open_mouth:"],
  [0, 1, 23, ":grimacing:"],
  [0, 1, 24, ":neutral_face:"],
  [0, 1, 25, ":confused:"],
  [0, 1, 26, ":hushed:"],
  [0, 2, 0, ":no_mouth:"],
  [0, 2, 1, ":innocent:"],
  [0, 2, 2, ":smirk:"],
  [0, 2, 3, ":expressionless:"],
  [0, 2, 4, ":man_with_gua_pi_mao:"],
  [0, 2, 5, ":man_with_turban:"],
  [0, 2, 6, ":cop:"],
  [0, 2, 7, ":construction_worker:"],
  [0, 2, 8, ":guardsman:"],
  [0, 2, 9, ":baby:"],
  [0, 2, 10, ":boy:"],
  [0, 2, 11, ":girl:"],
  [0, 2, 12, ":man:"],
  [0, 2, 13, ":woman:"],
  [0, 2, 14, ":older_man:"],
  [0, 2, 15, ":older_woman:"],
  [0, 2, 16, ":person_with_blond_hair:"],
  [0, 2, 17, ":angel:"],
  [0, 2, 18, ":princess:"],
  [0, 2, 19, ":smiley_cat:"],
  [0, 2, 20, ":smile_cat:"],
  [0, 2, 21, ":heart_eyes_cat:"],
  [0, 2, 22, ":kissing_cat:"],
  [0, 2, 23, ":smirk_cat:"],
  [0, 2, 24, ":scream_cat:"],
  [0, 2, 25, ":crying_cat_face:"],
  [0, 2, 26, ":joy_cat:"],
  [0, 3, 0, ":pouting_cat:"],
  [0, 3, 1, ":japanese_ogre:"],
  [0, 3, 2, ":japanese_goblin:"],
  [0, 3, 3, ":see_no_evil:"],
  [0, 3, 4, ":hear_no_evil:"],
  [0, 3, 5, ":speak_no_evil:"],
  [0, 3, 6, ":skull:"],
  [0, 3, 7, ":alien:"],
  [0, 3, 8, ":hankey:"],
  [0, 3, 9, ":fire:"],
  [0, 3, 10, ":sparkles:"],
  [0, 3, 11, ":star2:"],
  [0, 3, 12, ":dizzy:"],
  [0, 3, 13, ":boom:"],
  [0, 3, 14, ":anger:"],
  [0, 3, 15, ":sweat_drops:"],
  [0, 3, 16, ":droplet:"],
  [0, 3, 17, ":zzz:"],
  [0, 3, 18, ":dash:"],
  [0, 3, 19, ":ear:"],
  [0, 3, 20, ":eyes:"],
  [0, 3, 21, ":nose:"],
  [0, 3, 22, ":tongue:"],
  [0, 3, 23, ":lips:"],
  [0, 3, 24, ":+1:"],
  [0, 3, 25, ":-1:"],
  [0, 3, 26, ":ok_hand:"],
  [0, 4, 0, ":facepunch:"],
  [0, 4, 1, ":fist:"],
  [0, 4, 2, ":v:"],
  [0, 4, 3, ":wave:"],
  [0, 4, 4, ":hand:"],
  [0, 4, 5, ":open_hands:"],
  [0, 4, 6, ":point_up_2:"],
  [0, 4, 7, ":point_down:"],
  [0, 4, 8, ":point_right:"],
  [0, 4, 9, ":point_left:"],
  [0, 4, 10, ":raised_hands:"],
  [0, 4, 11, ":pray:"],
  [0, 4, 12, ":point_up:"],
  [0, 4, 13, ":clap:"],
  [0, 4, 14, ":muscle:"],
  [0, 4, 15, ":walking:"],
  [0, 4, 16, ":runner:"],
  [0, 4, 17, ":dancer:"],
  [0, 4, 18, ":couple:"],
  [0, 4, 19, ":family:"],
  [0, 4, 20, ":two_men_holding_hands:"],
  [0, 4, 21, ":two_women_holding_hands:"],
  [0, 4, 22, ":couplekiss:"],
  [0, 4, 23, ":couple_with_heart:"],
  [0, 4, 24, ":dancers:"],
  [0, 4, 25, ":ok_woman:"],
  [0, 4, 26, ":no_good:"],
  [0, 5, 0, ":information_desk_person:"],
  [0, 5, 1, ":raising_hand:"],
  [0, 5, 2, ":massage:"],
  [0, 5, 3, ":haircut:"],
  [0, 5, 4, ":nail_care:"],
  [0, 5, 5, ":bride_with_veil:"],
  [0, 5, 6, ":person_with_pouting_face:"],
  [0, 5, 7, ":person_frowning:"],
  [0, 5, 8, ":bow:"],
  [0, 5, 9, ":tophat:"],
  [0, 5, 10, ":crown:"],
  [0, 5, 11, ":womans_hat:"],
  [0, 5, 12, ":athletic_shoe:"],
  [0, 5, 13, ":mans_shoe:"],
  [0, 5, 14, ":sandal:"],
  [0, 5, 15, ":high_heel:"],
  [0, 5, 16, ":boot:"],
  [0, 5, 17, ":shirt:"],
  [0, 5, 18, ":necktie:"],
  [0, 5, 19, ":womans_clothes:"],
  [0, 5, 20, ":dress:"],
  [0, 5, 21, ":running_shirt_with_sash:"],
  [0, 5, 22, ":jeans:"],
  [0, 5, 23, ":kimono:"],
  [0, 5, 24, ":bikini:"],
  [0, 5, 25, ":briefcase:"],
  [0, 5, 26, ":handbag:"],
  [0, 6, 0, ":pouch:"],
  [0, 6, 1, ":purse:"],
  [0, 6, 2, ":eyeglasses:"],
  [0, 6, 3, ":ribbon:"],
  [0, 6, 4, ":closed_umbrella:"],
  [0, 6, 5, ":lipstick:"],
  [0, 6, 6, ":yellow_heart:"],
  [0, 6, 7, ":blue_heart:"],
  [0, 6, 8, ":purple_heart:"],
  [0, 6, 9, ":green_heart:"],
  [0, 6, 10, ":heart:"],
  [0, 6, 11, ":broken_heart:"],
  [0, 6, 12, ":heartpulse:"],
  [0, 6, 13, ":heartbeat:"],
  [0, 6, 14, ":two_hearts:"],
  [0, 6, 15, ":sparkling_heart:"],
  [0, 6, 16, ":revolving_hearts:"],
  [0, 6, 17, ":cupid:"],
  [0, 6, 18, ":love_letter:"],
  [0, 6, 19, ":kiss:"],
  [0, 6, 20, ":ring:"],
  [0, 6, 21, ":gem:"],
  [0, 6, 22, ":bust_in_silhouette:"],
  [0, 6, 23, ":busts_in_silhouette:"],
  [0, 6, 24, ":speech_balloon:"],
  [0, 6, 25, ":footprints:"],
  [0, 6, 26, ":thought_balloon:"],
  [1, 0, 0, ":dog:"],
  [1, 0, 1, ":wolf:"],
  [1, 0, 2, ":cat:"],
  [1, 0, 3, ":mouse:"],
  [1, 0, 4, ":hamster:"],
  [1, 0, 5, ":rabbit:"],
  [1, 0, 6, ":frog:"],
  [1, 0, 7, ":tiger:"],
  [1, 0, 8, ":koala:"],
  [1, 0, 9, ":bear:"],
  [1, 0, 10, ":pig:"],
  [1, 0, 11, ":pig_nose:"],
  [1, 0, 12, ":cow:"],
  [1, 0, 13, ":boar:"],
  [1, 0, 14, ":monkey_face:"],
  [1, 0, 15, ":monkey:"],
  [1, 0, 16, ":horse:"],
  [1, 0, 17, ":sheep:"],
  [1, 0, 18, ":elephant:"],
  [1, 0, 19, ":panda_face:"],
  [1, 0, 20, ":penguin:"],
  [1, 0, 21, ":bird:"],
  [1, 0, 22, ":baby_chick:"],
  [1, 0, 23, ":hatched_chick:"],
  [1, 0, 24, ":hatching_chick:"],
  [1, 0, 25, ":chicken:"],
  [1, 0, 26, ":snake:"],
  [1, 0, 27, ":turtle:"],
  [1, 0, 28, ":bug:"],
  [1, 1, 0, ":bee:"],
  [1, 1, 1, ":ant:"],
  [1, 1, 2, ":beetle:"],
  [1, 1, 3, ":snail:"],
  [1, 1, 4, ":octopus:"],
  [1, 1, 5, ":shell:"],
  [1, 1, 6, ":tropical_fish:"],
  [1, 1, 7, ":fish:"],
  [1, 1, 8, ":dolphin:"],
  [1, 1, 9, ":whale:"],
  [1, 1, 10, ":whale2:"],
  [1, 1, 11, ":cow2:"],
  [1, 1, 12, ":ram:"],
  [1, 1, 13, ":rat:"],
  [1, 1, 14, ":water_buffalo:"],
  [1, 1, 15, ":tiger2:"],
  [1, 1, 16, ":rabbit2:"],
  [1, 1, 17, ":dragon:"],
  [1, 1, 18, ":racehorse:"],
  [1, 1, 19, ":goat:"],
  [1, 1, 20, ":rooster:"],
  [1, 1, 21, ":dog2:"],
  [1, 1, 22, ":pig2:"],
  [1, 1, 23, ":mouse2:"],
  [1, 1, 24, ":ox:"],
  [1, 1, 25, ":dragon_face:"],
  [1, 1, 26, ":blowfish:"],
  [1, 1, 27, ":crocodile:"],
  [1, 1, 28, ":camel:"],
  [1, 2, 0, ":dromedary_camel:"],
  [1, 2, 1, ":leopard:"],
  [1, 2, 2, ":cat2:"],
  [1, 2, 3, ":poodle:"],
  [1, 2, 4, ":feet:"],
  [1, 2, 5, ":bouquet:"],
  [1, 2, 6, ":cherry_blossom:"],
  [1, 2, 7, ":tulip:"],
  [1, 2, 8, ":four_leaf_clover:"],
  [1, 2, 9, ":rose:"],
  [1, 2, 10, ":sunflower:"],
  [1, 2, 11, ":hibiscus:"],
  [1, 2, 12, ":maple_leaf:"],
  [1, 2, 13, ":leaves:"],
  [1, 2, 14, ":fallen_leaf:"],
  [1, 2, 15, ":herb:"],
  [1, 2, 16, ":ear_of_rice:"],
  [1, 2, 17, ":mushroom:"],
  [1, 2, 18, ":cactus:"],
  [1, 2, 19, ":palm_tree:"],
  [1, 2, 20, ":evergreen_tree:"],
  [1, 2, 21, ":deciduous_tree:"],
  [1, 2, 22, ":chestnut:"],
  [1, 2, 23, ":seedling:"],
  [1, 2, 24, ":blossom:"],
  [1, 2, 25, ":globe_with_meridians:"],
  [1, 2, 26, ":sun_with_face:"],
  [1, 2, 27, ":full_moon_with_face:"],
  [1, 2, 28, ":new_moon_with_face:"],
  [1, 3, 0, ":new_moon:"],
  [1, 3, 1, ":waxing_crescent_moon:"],
  [1, 3, 2, ":first_quarter_moon:"],
  [1, 3, 3, ":moon:"],
  [1, 3, 4, ":full_moon:"],
  [1, 3, 5, ":waning_gibbous_moon:"],
  [1, 3, 6, ":last_quarter_moon:"],
  [1, 3, 7, ":waning_crescent_moon:"],
  [1, 3, 8, ":last_quarter_moon_with_face:"],
  [1, 3, 9, ":first_quarter_moon_with_face:"],
  [1, 3, 10, ":crescent_moon:"],
  [1, 3, 11, ":earth_africa:"],
  [1, 3, 12, ":earth_americas:"],
  [1, 3, 13, ":earth_asia:"],
  [1, 3, 14, ":volcano:"],
  [1, 3, 15, ":milky_way:"],
  [1, 3, 16, ":stars:"],
  [1, 3, 17, ":star:"],
  [1, 3, 18, ":sunny:"],
  [1, 3, 19, ":partly_sunny:"],
  [1, 3, 20, ":cloud:"],
  [1, 3, 21, ":zap:"],
  [1, 3, 22, ":umbrella:"],
  [1, 3, 23, ":snowflake:"],
  [1, 3, 24, ":snowman:"],
  [1, 3, 25, ":cyclone:"],
  [1, 3, 26, ":foggy:"],
  [1, 3, 27, ":rainbow:"],
  [1, 3, 28, ":ocean:"],
  [2, 0, 0, ":bamboo:"],
  [2, 0, 1, ":gift_heart:"],
  [2, 0, 2, ":dolls:"],
  [2, 0, 3, ":school_satchel:"],
  [2, 0, 4, ":mortar_board:"],
  [2, 0, 5, ":flags:"],
  [2, 0, 6, ":fireworks:"],
  [2, 0, 7, ":sparkler:"],
  [2, 0, 8, ":wind_chime:"],
  [2, 0, 9, ":rice_scene:"],
  [2, 0, 10, ":jack_o_lantern:"],
  [2, 0, 11, ":ghost:"],
  [2, 0, 12, ":santa:"],
  [2, 0, 13, ":christmas_tree:"],
  [2, 0, 14, ":gift:"],
  [2, 0, 15, ":tanabata_tree:"],
  [2, 0, 16, ":tada:"],
  [2, 0, 17, ":confetti_ball:"],
  [2, 0, 18, ":balloon:"],
  [2, 0, 19, ":crossed_flags:"],
  [2, 0, 20, ":crystal_ball:"],
  [2, 0, 21, ":movie_camera:"],
  [2, 0, 22, ":camera:"],
  [2, 0, 23, ":video_camera:"],
  [2, 0, 24, ":vhs:"],
  [2, 0, 25, ":cd:"],
  [2, 0, 26, ":dvd:"],
  [2, 0, 27, ":minidisc:"],
  [2, 0, 28, ":floppy_disk:"],
  [2, 0, 29, ":computer:"],
  [2, 0, 30, ":iphone:"],
  [2, 0, 31, ":phone:"],
  [2, 0, 32, ":telephone_receiver:"],
  [2, 1, 0, ":pager:"],
  [2, 1, 1, ":fax:"],
  [2, 1, 2, ":satellite:"],
  [2, 1, 3, ":tv:"],
  [2, 1, 4, ":radio:"],
  [2, 1, 5, ":loud_sound:"],
  [2, 1, 6, ":sound:"],
  [2, 1, 7, ":speaker:"],
  [2, 1, 8, ":mute:"],
  [2, 1, 9, ":bell:"],
  [2, 1, 10, ":no_bell:"],
  [2, 1, 11, ":mega:"],
  [2, 1, 12, ":loudspeaker:"],
  [2, 1, 13, ":hourglass_flowing_sand:"],
  [2, 1, 14, ":hourglass:"],
  [2, 1, 15, ":alarm_clock:"],
  [2, 1, 16, ":watch:"],
  [2, 1, 17, ":unlock:"],
  [2, 1, 18, ":lock:"],
  [2, 1, 19, ":lock_with_ink_pen:"],
  [2, 1, 20, ":closed_lock_with_key:"],
  [2, 1, 21, ":key:"],
  [2, 1, 22, ":mag_right:"],
  [2, 1, 23, ":bulb:"],
  [2, 1, 24, ":flashlight:"],
  [2, 1, 25, ":high_brightness:"],
  [2, 1, 26, ":low_brightness:"],
  [2, 1, 27, ":electric_plug:"],
  [2, 1, 28, ":battery:"],
  [2, 1, 29, ":mag:"],
  [2, 1, 30, ":bath:"],
  [2, 1, 31, ":bathtub:"],
  [2, 1, 32, ":shower:"],
  [2, 2, 0, ":toilet:"],
  [2, 2, 1, ":wrench:"],
  [2, 2, 2, ":nut_and_bolt:"],
  [2, 2, 3, ":hammer:"],
  [2, 2, 4, ":door:"],
  [2, 2, 5, ":smoking:"],
  [2, 2, 6, ":bomb:"],
  [2, 2, 7, ":gun:"],
  [2, 2, 8, ":hocho:"],
  [2, 2, 9, ":pill:"],
  [2, 2, 10, ":syringe:"],
  [2, 2, 11, ":moneybag:"],
  [2, 2, 12, ":yen:"],
  [2, 2, 13, ":dollar:"],
  [2, 2, 14, ":pound:"],
  [2, 2, 15, ":euro:"],
  [2, 2, 16, ":credit_card:"],
  [2, 2, 17, ":money_with_wings:"],
  [2, 2, 18, ":calling:"],
  [2, 2, 19, ":e-mail:"],
  [2, 2, 20, ":inbox_tray:"],
  [2, 2, 21, ":outbox_tray:"],
  [2, 2, 22, ":email:"],
  [2, 2, 23, ":envelope_with_arrow:"],
  [2, 2, 24, ":incoming_envelope:"],
  [2, 2, 25, ":postal_horn:"],
  [2, 2, 26, ":mailbox:"],
  [2, 2, 27, ":mailbox_closed:"],
  [2, 2, 28, ":mailbox_with_mail:"],
  [2, 2, 29, ":mailbox_with_no_mail:"],
  [2, 2, 30, ":postbox:"],
  [2, 2, 31, ":package:"],
  [2, 2, 32, ":memo:"],
  [2, 3, 0, ":page_facing_up:"],
  [2, 3, 1, ":page_with_curl:"],
  [2, 3, 2, ":bookmark_tabs:"],
  [2, 3, 3, ":bar_chart:"],
  [2, 3, 4, ":chart_with_upwards_trend:"],
  [2, 3, 5, ":chart_with_downwards_trend:"],
  [2, 3, 6, ":scroll:"],
  [2, 3, 7, ":clipboard:"],
  [2, 3, 8, ":date:"],
  [2, 3, 9, ":calendar:"],
  [2, 3, 10, ":card_index:"],
  [2, 3, 11, ":file_folder:"],
  [2, 3, 12, ":open_file_folder:"],
  [2, 3, 13, ":scissors:"],
  [2, 3, 14, ":pushpin:"],
  [2, 3, 15, ":paperclip:"],
  [2, 3, 16, ":black_nib:"],
  [2, 3, 17, ":pencil2:"],
  [2, 3, 18, ":straight_ruler:"],
  [2, 3, 19, ":triangular_ruler:"],
  [2, 3, 20, ":closed_book:"],
  [2, 3, 21, ":green_book:"],
  [2, 3, 22, ":blue_book:"],
  [2, 3, 23, ":orange_book:"],
  [2, 3, 24, ":notebook:"],
  [2, 3, 25, ":notebook_with_decorative_cover:"],
  [2, 3, 26, ":ledger:"],
  [2, 3, 27, ":books:"],
  [2, 3, 28, ":book:"],
  [2, 3, 29, ":bookmark:"],
  [2, 3, 30, ":name_badge:"],
  [2, 3, 31, ":microscope:"],
  [2, 3, 32, ":telescope:"],
  [2, 4, 0, ":newspaper:"],
  [2, 4, 1, ":art:"],
  [2, 4, 2, ":clapper:"],
  [2, 4, 3, ":microphone:"],
  [2, 4, 4, ":headphones:"],
  [2, 4, 5, ":musical_score:"],
  [2, 4, 6, ":musical_note:"],
  [2, 4, 7, ":notes:"],
  [2, 4, 8, ":musical_keyboard:"],
  [2, 4, 9, ":violin:"],
  [2, 4, 10, ":trumpet:"],
  [2, 4, 11, ":saxophone:"],
  [2, 4, 12, ":guitar:"],
  [2, 4, 13, ":space_invader:"],
  [2, 4, 14, ":video_game:"],
  [2, 4, 15, ":black_joker:"],
  [2, 4, 16, ":flower_playing_cards:"],
  [2, 4, 17, ":mahjong:"],
  [2, 4, 18, ":game_die:"],
  [2, 4, 19, ":dart:"],
  [2, 4, 20, ":football:"],
  [2, 4, 21, ":basketball:"],
  [2, 4, 22, ":soccer:"],
  [2, 4, 23, ":baseball:"],
  [2, 4, 24, ":tennis:"],
  [2, 4, 25, ":8ball:"],
  [2, 4, 26, ":rugby_football:"],
  [2, 4, 27, ":bowling:"],
  [2, 4, 28, ":golf:"],
  [2, 4, 29, ":mountain_bicyclist:"],
  [2, 4, 30, ":bicyclist:"],
  [2, 4, 31, ":checkered_flag:"],
  [2, 4, 32, ":horse_racing:"],
  [2, 5, 0, ":trophy:"],
  [2, 5, 1, ":ski:"],
  [2, 5, 2, ":snowboarder:"],
  [2, 5, 3, ":swimmer:"],
  [2, 5, 4, ":surfer:"],
  [2, 5, 5, ":fishing_pole_and_fish:"],
  [2, 5, 6, ":coffee:"],
  [2, 5, 7, ":tea:"],
  [2, 5, 8, ":sake:"],
  [2, 5, 9, ":baby_bottle:"],
  [2, 5, 10, ":beer:"],
  [2, 5, 11, ":beers:"],
  [2, 5, 12, ":cocktail:"],
  [2, 5, 13, ":tropical_drink:"],
  [2, 5, 14, ":wine_glass:"],
  [2, 5, 15, ":fork_and_knife:"],
  [2, 5, 16, ":pizza:"],
  [2, 5, 17, ":hamburger:"],
  [2, 5, 18, ":fries:"],
  [2, 5, 19, ":poultry_leg:"],
  [2, 5, 20, ":meat_on_bone:"],
  [2, 5, 21, ":spaghetti:"],
  [2, 5, 22, ":curry:"],
  [2, 5, 23, ":fried_shrimp:"],
  [2, 5, 24, ":bento:"],
  [2, 5, 25, ":sushi:"],
  [2, 5, 26, ":fish_cake:"],
  [2, 5, 27, ":rice_ball:"],
  [2, 5, 28, ":rice_cracker:"],
  [2, 5, 29, ":rice:"],
  [2, 5, 30, ":ramen:"],
  [2, 5, 31, ":stew:"],
  [2, 5, 32, ":oden:"],
  [2, 6, 0, ":dango:"],
  [2, 6, 1, ":egg:"],
  [2, 6, 2, ":bread:"],
  [2, 6, 3, ":doughnut:"],
  [2, 6, 4, ":custard:"],
  [2, 6, 5, ":icecream:"],
  [2, 6, 6, ":ice_cream:"],
  [2, 6, 7, ":shaved_ice:"],
  [2, 6, 8, ":birthday:"],
  [2, 6, 9, ":cake:"],
  [2, 6, 10, ":cookie:"],
  [2, 6, 11, ":chocolate_bar:"],
  [2, 6, 12, ":candy:"],
  [2, 6, 13, ":lollipop:"],
  [2, 6, 14, ":honey_pot:"],
  [2, 6, 15, ":apple:"],
  [2, 6, 16, ":green_apple:"],
  [2, 6, 17, ":tangerine:"],
  [2, 6, 18, ":lemon:"],
  [2, 6, 19, ":cherries:"],
  [2, 6, 20, ":grapes:"],
  [2, 6, 21, ":watermelon:"],
  [2, 6, 22, ":strawberry:"],
  [2, 6, 23, ":peach:"],
  [2, 6, 24, ":melon:"],
  [2, 6, 25, ":banana:"],
  [2, 6, 26, ":pear:"],
  [2, 6, 27, ":pineapple:"],
  [2, 6, 28, ":sweet_potato:"],
  [2, 6, 29, ":eggplant:"],
  [2, 6, 30, ":tomato:"],
  [2, 6, 31, ":corn:"],
  [3, 0, 0, ":house:"],
  [3, 0, 1, ":house_with_garden:"],
  [3, 0, 2, ":school:"],
  [3, 0, 3, ":office:"],
  [3, 0, 4, ":post_office:"],
  [3, 0, 5, ":hospital:"],
  [3, 0, 6, ":bank:"],
  [3, 0, 7, ":convenience_store:"],
  [3, 0, 8, ":love_hotel:"],
  [3, 0, 9, ":hotel:"],
  [3, 0, 10, ":wedding:"],
  [3, 0, 11, ":church:"],
  [3, 0, 12, ":department_store:"],
  [3, 0, 13, ":european_post_office:"],
  [3, 0, 14, ":city_sunrise:"],
  [3, 0, 15, ":city_sunset:"],
  [3, 0, 16, ":japanese_castle:"],
  [3, 0, 17, ":european_castle:"],
  [3, 0, 18, ":tent:"],
  [3, 0, 19, ":factory:"],
  [3, 0, 20, ":tokyo_tower:"],
  [3, 0, 21, ":japan:"],
  [3, 0, 22, ":mount_fuji:"],
  [3, 0, 23, ":sunrise_over_mountains:"],
  [3, 0, 24, ":sunrise:"],
  [3, 0, 25, ":night_with_stars:"],
  [3, 0, 26, ":statue_of_liberty:"],
  [3, 0, 27, ":bridge_at_night:"],
  [3, 0, 28, ":carousel_horse:"],
  [3, 0, 29, ":ferris_wheel:"],
  [3, 0, 30, ":fountain:"],
  [3, 0, 31, ":roller_coaster:"],
  [3, 0, 32, ":ship:"],
  [3, 0, 33, ":boat:"],
  [3, 1, 0, ":speedboat:"],
  [3, 1, 1, ":rowboat:"],
  [3, 1, 2, ":anchor:"],
  [3, 1, 3, ":rocket:"],
  [3, 1, 4, ":airplane:"],
  [3, 1, 5, ":seat:"],
  [3, 1, 6, ":helicopter:"],
  [3, 1, 7, ":steam_locomotive:"],
  [3, 1, 8, ":tram:"],
  [3, 1, 9, ":station:"],
  [3, 1, 10, ":mountain_railway:"],
  [3, 1, 11, ":train2:"],
  [3, 1, 12, ":bullettrain_side:"],
  [3, 1, 13, ":bullettrain_front:"],
  [3, 1, 14, ":light_rail:"],
  [3, 1, 15, ":metro:"],
  [3, 1, 16, ":monorail:"],
  [3, 1, 17, ":railway_car:"],
  [3, 1, 18, ":train:"],
  [3, 1, 19, ":trolleybus:"],
  [3, 1, 20, ":bus:"],
  [3, 1, 21, ":oncoming_bus:"],
  [3, 1, 22, ":blue_car:"],
  [3, 1, 23, ":oncoming_automobile:"],
  [3, 1, 24, ":car:"],
  [3, 1, 25, ":taxi:"],
  [3, 1, 26, ":oncoming_taxi:"],
  [3, 1, 27, ":articulated_lorry:"],
  [3, 1, 28, ":truck:"],
  [3, 1, 29, ":rotating_light:"],
  [3, 1, 30, ":police_car:"],
  [3, 1, 31, ":oncoming_police_car:"],
  [3, 1, 32, ":fire_engine:"],
  [3, 1, 33, ":ambulance:"],
  [3, 2, 0, ":minibus:"],
  [3, 2, 1, ":bike:"],
  [3, 2, 2, ":aerial_tramway:"],
  [3, 2, 3, ":suspension_railway:"],
  [3, 2, 4, ":mountain_cableway:"],
  [3, 2, 5, ":tractor:"],
  [3, 2, 6, ":barber:"],
  [3, 2, 7, ":busstop:"],
  [3, 2, 8, ":ticket:"],
  [3, 2, 9, ":vertical_traffic_light:"],
  [3, 2, 10, ":traffic_light:"],
  [3, 2, 11, ":warning:"],
  [3, 2, 12, ":construction:"],
  [3, 2, 13, ":beginner:"],
  [3, 2, 14, ":fuelpump:"],
  [3, 2, 15, ":izakaya_lantern:"],
  [3, 2, 16, ":slot_machine:"],
  [3, 2, 17, ":hotsprings:"],
  [3, 2, 18, ":moyai:"],
  [3, 2, 19, ":circus_tent:"],
  [3, 2, 20, ":performing_arts:"],
  [3, 2, 21, ":round_pushpin:"],
  [3, 2, 22, ":triangular_flag_on_post:"],
  [3, 2, 23, ":jp:"],
  [3, 2, 24, ":kr:"],
  [3, 2, 25, ":de:"],
  [3, 2, 26, ":cn:"],
  [3, 2, 27, ":us:"],
  [3, 2, 28, ":fr:"],
  [3, 2, 29, ":es:"],
  [3, 2, 30, ":it:"],
  [3, 2, 31, ":ru:"],
  [3, 2, 32, ":gb:"],
  [4, 0, 0, ":one:"],
  [4, 0, 1, ":two:"],
  [4, 0, 2, ":three:"],
  [4, 0, 3, ":four:"],
  [4, 0, 4, ":five:"],
  [4, 0, 5, ":six:"],
  [4, 0, 6, ":seven:"],
  [4, 0, 7, ":eight:"],
  [4, 0, 8, ":nine:"],
  [4, 0, 9, ":zero:"],
  [4, 0, 10, ":keycap_ten:"],
  [4, 0, 11, ":1234:"],
  [4, 0, 12, ":hash:"],
  [4, 0, 13, ":symbols:"],
  [4, 0, 14, ":arrow_up:"],
  [4, 0, 15, ":arrow_down:"],
  [4, 0, 16, ":arrow_left:"],
  [4, 0, 17, ":arrow_right:"],
  [4, 0, 18, ":capital_abcd:"],
  [4, 0, 19, ":abcd:"],
  [4, 0, 20, ":abc:"],
  [4, 0, 21, ":arrow_upper_right:"],
  [4, 0, 22, ":arrow_upper_left:"],
  [4, 0, 23, ":arrow_lower_right:"],
  [4, 0, 24, ":arrow_lower_left:"],
  [4, 0, 25, ":left_right_arrow:"],
  [4, 0, 26, ":arrow_up_down:"],
  [4, 0, 27, ":arrows_counterclockwise:"],
  [4, 0, 28, ":arrow_backward:"],
  [4, 0, 29, ":arrow_forward:"],
  [4, 0, 30, ":arrow_up_small:"],
  [4, 0, 31, ":arrow_down_small:"],
  [4, 0, 32, ":leftwards_arrow_with_hook:"],
  [4, 0, 33, ":arrow_right_hook:"],
  [4, 1, 0, ":information_source:"],
  [4, 1, 1, ":rewind:"],
  [4, 1, 2, ":fast_forward:"],
  [4, 1, 3, ":arrow_double_up:"],
  [4, 1, 4, ":arrow_double_down:"],
  [4, 1, 5, ":arrow_heading_down:"],
  [4, 1, 6, ":arrow_heading_up:"],
  [4, 1, 7, ":ok:"],
  [4, 1, 8, ":twisted_rightwards_arrows:"],
  [4, 1, 9, ":repeat:"],
  [4, 1, 10, ":repeat_one:"],
  [4, 1, 11, ":new:"],
  [4, 1, 12, ":up:"],
  [4, 1, 13, ":cool:"],
  [4, 1, 14, ":free:"],
  [4, 1, 15, ":ng:"],
  [4, 1, 16, ":signal_strength:"],
  [4, 1, 17, ":cinema:"],
  [4, 1, 18, ":koko:"],
  [4, 1, 19, ":u6307:"],
  [4, 1, 20, ":u7a7a:"],
  [4, 1, 21, ":u6e80:"],
  [4, 1, 22, ":u5408:"],
  [4, 1, 23, ":u7981:"],
  [4, 1, 24, ":ideograph_advantage:"],
  [4, 1, 25, ":u5272:"],
  [4, 1, 26, ":u55b6:"],
  [4, 1, 27, ":u6709:"],
  [4, 1, 28, ":u7121:"],
  [4, 1, 29, ":restroom:"],
  [4, 1, 30, ":mens:"],
  [4, 1, 31, ":womens:"],
  [4, 1, 32, ":baby_symbol:"],
  [4, 1, 33, ":wc:"],
  [4, 2, 0, ":potable_water:"],
  [4, 2, 1, ":put_litter_in_its_place:"],
  [4, 2, 2, ":parking:"],
  [4, 2, 3, ":wheelchair:"],
  [4, 2, 4, ":no_smoking:"],
  [4, 2, 5, ":u6708:"],
  [4, 2, 6, ":u7533:"],
  [4, 2, 7, ":sa:"],
  [4, 2, 8, ":m:"],
  [4, 2, 9, ":passport_control:"],
  [4, 2, 10, ":baggage_claim:"],
  [4, 2, 11, ":left_luggage:"],
  [4, 2, 12, ":customs:"],
  [4, 2, 13, ":accept:"],
  [4, 2, 14, ":secret:"],
  [4, 2, 15, ":congratulations:"],
  [4, 2, 16, ":cl:"],
  [4, 2, 17, ":sos:"],
  [4, 2, 18, ":id:"],
  [4, 2, 19, ":no_entry_sign:"],
  [4, 2, 20, ":underage:"],
  [4, 2, 21, ":no_mobile_phones:"],
  [4, 2, 22, ":do_not_litter:"],
  [4, 2, 23, ":non-potable_water:"],
  [4, 2, 24, ":no_bicycles:"],
  [4, 2, 25, ":no_pedestrians:"],
  [4, 2, 26, ":children_crossing:"],
  [4, 2, 27, ":no_entry:"],
  [4, 2, 28, ":eight_spoked_asterisk:"],
  [4, 2, 29, ":sparkle:"],
  [4, 2, 30, ":negative_squared_cross_mark:"],
  [4, 2, 31, ":white_check_mark:"],
  [4, 2, 32, ":eight_pointed_black_star:"],
  [4, 2, 33, ":heart_decoration:"],
  [4, 3, 0, ":vs:"],
  [4, 3, 1, ":vibration_mode:"],
  [4, 3, 2, ":mobile_phone_off:"],
  [4, 3, 3, ":a:"],
  [4, 3, 4, ":b:"],
  [4, 3, 5, ":ab:"],
  [4, 3, 6, ":o2:"],
  [4, 3, 7, ":diamond_shape_with_a_dot_inside:"],
  [4, 3, 8, ":loop:"],
  [4, 3, 9, ":recycle:"],
  [4, 3, 10, ":aries:"],
  [4, 3, 11, ":taurus:"],
  [4, 3, 12, ":gemini:"],
  [4, 3, 13, ":cancer:"],
  [4, 3, 14, ":leo:"],
  [4, 3, 15, ":virgo:"],
  [4, 3, 16, ":libra:"],
  [4, 3, 17, ":scorpius:"],
  [4, 3, 18, ":sagittarius:"],
  [4, 3, 19, ":capricorn:"],
  [4, 3, 20, ":aquarius:"],
  [4, 3, 21, ":pisces:"],
  [4, 3, 22, ":ophiuchus:"],
  [4, 3, 23, ":six_pointed_star:"],
  [4, 3, 24, ":atm:"],
  [4, 3, 25, ":chart:"],
  [4, 3, 26, ":heavy_dollar_sign:"],
  [4, 3, 27, ":currency_exchange:"],
  [4, 3, 28, ":copyright:"],
  [4, 3, 29, ":registered:"],
  [4, 3, 30, ":tm:"],
  [4, 3, 31, ":x:"],
  [4, 3, 32, ":bangbang:"],
  [4, 3, 33, ":interrobang:"],
  [4, 4, 0, ":exclamation:"],
  [4, 4, 1, ":question:"],
  [4, 4, 2, ":grey_exclamation:"],
  [4, 4, 3, ":grey_question:"],
  [4, 4, 4, ":o:"],
  [4, 4, 5, ":top:"],
  [4, 4, 6, ":end:"],
  [4, 4, 7, ":back:"],
  [4, 4, 8, ":on:"],
  [4, 4, 9, ":soon:"],
  [4, 4, 10, ":arrows_clockwise:"],
  [4, 4, 11, ":clock12:"],
  [4, 4, 12, ":clock1230:"],
  [4, 4, 13, ":clock1:"],
  [4, 4, 14, ":clock130:"],
  [4, 4, 15, ":clock2:"],
  [4, 4, 16, ":clock230:"],
  [4, 4, 17, ":clock3:"],
  [4, 4, 18, ":clock330:"],
  [4, 4, 19, ":clock4:"],
  [4, 4, 20, ":clock430:"],
  [4, 4, 21, ":clock5:"],
  [4, 4, 22, ":clock530:"],
  [4, 4, 23, ":clock6:"],
  [4, 4, 24, ":clock7:"],
  [4, 4, 25, ":clock8:"],
  [4, 4, 26, ":clock9:"],
  [4, 4, 27, ":clock10:"],
  [4, 4, 28, ":clock11:"],
  [4, 4, 29, ":clock630:"],
  [4, 4, 30, ":clock730:"],
  [4, 4, 31, ":clock830:"],
  [4, 4, 32, ":clock930:"],
  [4, 4, 33, ":clock1030:"],
  [4, 5, 0, ":clock1130:"],
  [4, 5, 1, ":heavy_multiplication_x:"],
  [4, 5, 2, ":heavy_plus_sign:"],
  [4, 5, 3, ":heavy_minus_sign:"],
  [4, 5, 4, ":heavy_division_sign:"],
  [4, 5, 5, ":spades:"],
  [4, 5, 6, ":hearts:"],
  [4, 5, 7, ":clubs:"],
  [4, 5, 8, ":diamonds:"],
  [4, 5, 9, ":white_flower:"],
  [4, 5, 10, ":100:"],
  [4, 5, 11, ":heavy_check_mark:"],
  [4, 5, 12, ":ballot_box_with_check:"],
  [4, 5, 13, ":radio_button:"],
  [4, 5, 14, ":link:"],
  [4, 5, 15, ":curly_loop:"],
  [4, 5, 16, ":wavy_dash:"],
  [4, 5, 17, ":part_alternation_mark:"],
  [4, 5, 18, ":trident:"],
  [4, 5, 19, ":black_medium_square:"],
  [4, 5, 20, ":white_medium_square:"],
  [4, 5, 21, ":black_medium_small_square:"],
  [4, 5, 22, ":white_medium_small_square:"],
  [4, 5, 23, ":black_small_square:"],
  [4, 5, 24, ":white_small_square:"],
  [4, 5, 25, ":small_red_triangle:"],
  [4, 5, 26, ":black_square_button:"],
  [4, 5, 27, ":white_square_button:"],
  [4, 5, 28, ":black_circle:"],
  [4, 5, 29, ":white_circle:"],
  [4, 5, 30, ":red_circle:"],
  [4, 5, 31, ":large_blue_circle:"],
  [4, 5, 32, ":small_red_triangle_down:"],
  [4, 5, 33, ":white_large_square:"],
  [4, 6, 0, ":black_large_square:"],
  [4, 6, 1, ":large_orange_diamond:"],
  [4, 6, 2, ":large_blue_diamond:"],
  [4, 6, 3, ":small_orange_diamond:"],
  [4, 6, 4, ":small_blue_diamond:"],
];

export default Service.extend({
  emojiSet,

  iconSize: 25,

  groups: [
    'smile',
    'flower',
    'bell',
    'car',
    'grid',
  ],

  spriteSheetDimentions: [
    [7, 27],
    [4, 29],
    [7, 33],
    [3, 34],
    [7, 34],
  ],

  styledMap: computed('emojiSet', 'iconSize', 'spriteSheetDimentions', function() {
    const {
      emojiSet,
      iconSize,
      spriteSheetDimentions,
    } = getProperties(this, 'emojiSet', 'iconSize', 'spriteSheetDimentions');

    let result = {};

    emojiSet.forEach(([sheet, row, column, name]) => {
      result[name] = this.inlineIconStyle(row, sheet, column, iconSize, spriteSheetDimentions);
    });

    return result;
  }),

  groupedStyledMap: computed('styledMap', function() {
    const { groups, emojiSet, styledMap } = getProperties(this, 'groups', 'emojiSet', 'styledMap');

    let result = {};

    emojiSet.forEach(([sheet, row, column, name]) => {
      if (!result[groups[sheet]]) {
        result[groups[sheet]] = {};
      }

      result[groups[sheet]][name] = styledMap[name];
    });

    return result;
  }),

  inlineIconStyle(row, sheet, column, iconSize, spriteSheetDimentions) {
    return htmlSafe(
      "width:" + iconSize + "px;height:" + iconSize + "px;" +
      "background:url('/assets/emoji/emoji_spritesheet_" + sheet + ".png') -" +
      column * iconSize + "px -" + row * iconSize + "px no-repeat;background-size:" +
      spriteSheetDimentions[sheet][1] * iconSize + "px " +
      spriteSheetDimentions[sheet][0] * iconSize + "px;"
    );
  },
});