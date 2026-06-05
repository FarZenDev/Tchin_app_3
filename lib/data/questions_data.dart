import '../models/question_model.dart';

class QuestionData {
  final String text;
  final int players;
  final QuestionType type;

  const QuestionData({
    required this.text,
    required this.players,
    this.type = QuestionType.normal,
  });
}

class AppData {
  static const Map<String, List<QuestionData>> allQuestions = {
    'classic': [
      QuestionData(
          text:
              "🍻 {player1}, invente un cri de guerre nul. Toute la table le répète ou boit 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "📣 {player1}, fais une annonce officielle comme si la soirée était un conseil municipal. Si personne n'applaudit, bois 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🧾 {player1}, donne un faux ticket de caisse à {player2} : 2 gorgées pour mauvaise attitude.",
          players: 2),
      QuestionData(
          text:
              "🧦 {player1}, choisis le joueur qui a la dégaine la plus chaussette perdue. Il boit 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎤 {player1}, lis ta prochaine phrase comme une bande-annonce dramatique. Si tu oublies, bois 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🪑 {player1}, fais une déclaration d'amour à ta chaise. Si la table n'est pas émue, bois 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🧃 {player1}, crée le nom d'un cocktail horrible pour {player2}. S'il est trop faible, tu bois 2.",
          players: 2),
      QuestionData(
          text:
              "🚨 Tous ceux qui ont déjà dit je suis pas bourré boivent 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎲 {player1}, lance le dé. Le score devient ton niveau de honte et tes gorgées.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text:
              "👑 {player1}, tu deviens ministre des verres. Tu peux donner 1 gorgée à trois joueurs.",
          players: 1),
      QuestionData(
          text:
              "🧠 {player1}, cite 3 excuses nulles pour ne pas répondre à un message. Échec = 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🍟 {player1}, le dernier qui a mangé un truc gras boit 2 gorgées avec toi.",
          players: 1),
      QuestionData(
          text:
              "📱 {player1}, pose ton téléphone sur la table comme un objet sacré. Celui qui le touche avant ton prochain tour boit 3.",
          players: 1),
      QuestionData(
          text:
              "🎭 {player1}, imite {player2} qui commande un verre beaucoup trop sérieusement. Le perdant du rire boit 2.",
          players: 2),
      QuestionData(
          text:
              "🧢 {player1}, donne un surnom de fin de soirée à {player2}. Jusqu'au prochain tour, tout oubli vaut 1 gorgée.",
          players: 2),
      QuestionData(
          text:
              "🥂 {player1}, fais un toast à un objet de la pièce. Si quelqu'un rigole, il boit 1.",
          players: 1),
      QuestionData(
          text:
              "🔁 {player1}, inverse le sens du jeu et parle comme un GPS pendant 1 tour. Erreur = 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🕺 {player1}, fais 4 secondes de danse de victoire pour une raison inventée ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "🍺 {player1}, distribue 5 gorgées en expliquant chaque gorgée comme une sanction administrative.",
          players: 1),
      QuestionData(
          text: "🎡 {player1}, tourne la Roue de la Fortune.",
          players: 1,
          type: QuestionType.wheel),
      QuestionData(
          text:
              "Morpion ! ❌⭕ {player1} défie quelqu'un. Le perdant boit 3 gorgées.",
          players: 1,
          type: QuestionType.ticTacToe),
      QuestionData(
          text: "🎰 {player1}, tente le Jackpot du comptoir.",
          players: 1,
          type: QuestionType.slotMachine),
      QuestionData(
          text:
              "🪙 {player1}, pile tu bois 3, face tu fais boire {player2} 3. Si la pièce tombe mal, tout le monde boit 1.",
          players: 2),
      QuestionData(
          text:
              "🧊 {player1}, reste immobile 10 secondes comme si tu venais de comprendre ta vie. Si tu bouges, bois 2.",
          players: 1),
      QuestionData(
          text:
              "🏆 La table vote pour le joueur qui a la meilleure tête de lendemain difficile. Il distribue 4 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎁 {player1}, donne une immunité ridicule à {player2} : il peut éviter une gorgée en disant pardon patron.",
          players: 2),
      QuestionData(
          text:
              "🗣️ {player1}, raconte une anecdote en remplaçant un mot par bloup. Si tu oublies, bois 2.",
          players: 1),
      QuestionData(
          text:
              "🚫 Interdiction de dire soirée pendant 2 tours. {player1} surveille, chaque erreur vaut 1 gorgée.",
          players: 1),
      QuestionData(
          text:
              "🎯 {player1}, désigne celui qui ferait le pire influenceur alcoolisé. Il boit 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🛎️ {player1}, appelle le prochain joueur monsieur ou madame le problème. Si tu oublies, bois 2.",
          players: 1),
      QuestionData(
          text:
              "🥇 {player1}, invente une médaille débile pour {player2}. Il boit 2 s'il la refuse.",
          players: 2),
      QuestionData(
          text:
              "🍋 {player1}, cite 3 trucs qui sentent la défaite. Échec = 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "📸 {player1} et {player2}, prenez une pose de couverture d'album raté ou buvez chacun 2.",
          players: 2),
      QuestionData(
          text:
              "🧩 {player1}, fais deviner un métier sans parler. Si personne ne trouve, bois 3.",
          players: 1),
      QuestionData(
          text:
              "🏁 Dernier service soft : tout le monde boit 1 gorgée, {player1} donne un surnom au total de la table.",
          players: 1),
      QuestionData(
          text:
              "🧯 {player1}, invente une excuse pour expliquer pourquoi {player2} a l'air coupable. Le moins crédible boit 2.",
          players: 2),
      QuestionData(
          text:
              "🥄 {player1}, choisis un joueur qui a l'énergie d'une petite cuillère triste. Il boit 2.",
          players: 1),
      QuestionData(
          text:
              "📺 {player1}, présente {player2} comme candidat d'une émission nulle. Si la table zappe, bois 3.",
          players: 2),
      QuestionData(
          text:
              "🧼 {player1}, tout le monde vote pour celui qui a la meilleure tête de pub pour lessive. Il distribue 3.",
          players: 1),
      QuestionData(
          text:
              "🚕 {player1}, raconte ton dernier trajet gênant comme une enquête policière ou bois 2.",
          players: 1),
    ],
    'hard': [
      QuestionData(
          text:
              "🔥 {player1}, raconte une vérité honteuse avec une voix de présentateur télé ou bois 5 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🥃 {player1}, cul sec ou fais ton autoportrait moral en 10 secondes devant la table.",
          players: 1),
      QuestionData(
          text:
              "📵 {player1}, téléphone face visible jusqu'à ton prochain tour. Si tu refuses, 6 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🧨 {player1}, la table choisit ton nouveau prénom de soirée. Refus = shot.",
          players: 1),
      QuestionData(
          text:
              "👀 {player1}, donne le plus gros défaut de soirée de {player2}. Si c'est trop gentil, tu bois 4.",
          players: 2),
      QuestionData(
          text:
              "⚖️ Tribunal débile : {player1}, {player2} et {player3} votent pour le plus mythomane. Il boit 5.",
          players: 3),
      QuestionData(
          text:
              "🪓 {player1}, coupe la parole au prochain joueur avec une phrase dramatique. Si tu rates, bois 3.",
          players: 1),
      QuestionData(
          text:
              "🧾 {player1}, facture imaginaire : 2 gorgées pour manque de charisme, à donner à quelqu'un.",
          players: 1),
      QuestionData(
          text:
              "🔒 {player1}, tu n'as plus le droit de toucher ton verre avec ta main dominante. Erreur = 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🧠 {player1}, avoue une décision vraiment nulle de ces 30 derniers jours ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "🚪 {player1}, sors 5 secondes. La table décide ta peine entre 2 et 6 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎭 {player1}, plaide coupable pour un crime de soirée inventé. Si c'est nul, bois 4.",
          players: 1),
      QuestionData(
          text:
              "🥶 {player1}, lis une phrase banale comme si tu venais de perdre un procès. Si personne ne rit, bois 3.",
          players: 1),
      QuestionData(
          text:
              "🍺 {player1}, bois 1 gorgée par personne qui pense que tu mens trop bien.",
          players: 1),
      QuestionData(
          text:
              "💬 {player1}, {player2} te pose une question qui pique. Réponse ou 5 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🏴 {player1}, désigne le plus fourbe de la table. Il boit 4 et peut t'en rendre 1.",
          players: 1),
      QuestionData(
          text:
              "🎲 {player1}, lance le dé : pair tu distribues, impair tu bois, 6 = tu choisis quelqu'un pour un shot virtuel.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text:
              "🧃 {player1}, mélange deux boissons raisonnables. Tu bois 3 gorgées du résultat avec un air fier.",
          players: 1),
      QuestionData(
          text:
              "🕯️ {player1}, confession du comptoir : raconte une excuse pathétique que tu as déjà utilisée ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "🚨 {player1}, la table choisit une phrase que tu devras dire avant chaque gorgée pendant 2 tours.",
          players: 1),
      QuestionData(
          text:
              "😬 {player1}, appelle {player2} chef jusqu'à ton prochain tour. Oubli = 2 gorgées.",
          players: 2),
      QuestionData(
          text:
              "📱 {player1}, montre seulement le nom de ton dernier message reçu ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "🧯 {player1}, raconte la pire fois où tu as essayé de sauver une ambiance ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "👑 {player1}, donne un ordre absurde à la table. Celui qui refuse boit 3.",
          players: 1),
      QuestionData(
          text:
              "🪑 Tout le monde se lève. Le dernier assis boit 3 et doit dire je suis lent mais stable.",
          players: 1),
      QuestionData(
          text:
              "🗣️ {player1}, fais une déclaration publique à ton verre. Si le verre ne répond pas, bois 3.",
          players: 1),
      QuestionData(
          text:
              "🥃 {player1}, shot ou avoue un truc que tu fais seulement quand personne ne regarde.",
          players: 1),
      QuestionData(
          text:
              "💥 Carte choc : {player1}, accepte la prochaine pénalité sans négocier ou bois 6 maintenant.",
          players: 1),
      QuestionData(
          text:
              "🎯 {player1}, désigne la personne qui va envoyer le pire message ce soir. Elle boit 3.",
          players: 1),
      QuestionData(
          text:
              "🔁 {player1}, échange ton verre de main jusqu'au prochain tour. Erreur = 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🏁 Dernier avertissement : {player1}, bois 6 ou donne 2 gorgées à trois joueurs avec une excuse bidon.",
          players: 1),
      QuestionData(
          text:
              "🧻 {player1}, la table te donne une mission ridicule. Refus = 5 gorgées, exécution nulle = 3.",
          players: 1),
      QuestionData(
          text:
              "💼 {player1}, licencie officiellement {player2} de la soirée. Il boit 4 et peut faire appel.",
          players: 2),
      QuestionData(
          text:
              "📉 {player1}, annonce le bilan catastrophique de ta vie amoureuse. Si c'est trop vague, bois 5.",
          players: 1),
      QuestionData(
          text:
              "🎬 {player1}, joue ta dernière mauvaise décision en ralenti. Si personne ne comprend, bois 4.",
          players: 1),
      QuestionData(
          text:
              "🪦 {player1}, fais l'éloge funèbre de ta dignité. Si c'est court, bois 5.",
          players: 1),
      QuestionData(
          text:
              "🧨 {player1}, avoue un truc que tu as déjà nié avec trop de confiance ou bois 6.",
          players: 1),
    ],
    'duo': [
      QuestionData(
          text:
              "👥 {player1} et {player2}, inventez une poignée de main en 10 secondes ou buvez chacun 2.",
          players: 2),
      QuestionData(
          text:
              "🎭 {player1} accuse {player2} d'un crime débile. {player2} doit se défendre ou boire 3.",
          players: 2),
      QuestionData(
          text:
              "🤝 {player1} et {player2}, pacte de honte : si l'un boit au prochain tour, l'autre dit je l'assume et boit 1.",
          players: 2),
      QuestionData(
          text:
              "👀 {player1} et {player2}, duel de regard en pensant à une facture impayée. Le premier qui rit boit 3.",
          players: 2),
      QuestionData(
          text:
              "🎤 {player1} chante une phrase nulle, {player2} doit faire les percussions de bouche. Échec = 2 chacun.",
          players: 2),
      QuestionData(
          text:
              "🧠 {player1}, devine le dernier achat inutile de {player2}. Mauvais = 2 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🍺 {player1} et {player2}, créez une règle secrète. Le premier qui l'oublie boit 3.",
          players: 2),
      QuestionData(
          text:
              "📸 {player1} et {player2}, posez comme une affiche de film catastrophique ou buvez chacun 2.",
          players: 2),
      QuestionData(
          text:
              "🧾 Duo de caisse : {player1} donne 2 gorgées à {player2}, puis {player2} invente le motif.",
          players: 2),
      QuestionData(
          text:
              "🎯 {player1} défie {player2} : qui peut citer le plus de mauvais plans de soirée ? Perdant boit 3.",
          players: 2),
      QuestionData(
          text:
              "🥂 {player1} et {player2}, trinquez sans parler. Le premier qui fait un bruit gênant boit 2.",
          players: 2),
      QuestionData(
          text:
              "🔁 {player1} et {player2}, échangez vos rôles : l'un commande, l'autre obéit pendant 1 tour.",
          players: 2),
      QuestionData(
          text:
              "😏 {player1}, donne à {player2} un compliment et une insulte déguisée. Si c'est trop gentil, bois 3.",
          players: 2),
      QuestionData(
          text:
              "🪙 {player1} choisit pile ou face. {player2} lance. Perdant boit 3 et félicite l'autre.",
          players: 2),
      QuestionData(
          text:
              "🧊 {player1} et {player2}, restez sérieux pendant que la table choisit vos nouveaux métiers imaginaires. Rire = 2.",
          players: 2),
      QuestionData(
          text:
              "💬 {player1}, donne un conseil amoureux catastrophique à {player2}. Si c'est utilisable, vous buvez chacun 2.",
          players: 2),
      QuestionData(
          text:
              "🍻 {player1} et {player2}, chacun choisit une victime pour 2 gorgées. Si vous choisissez la même, vous buvez aussi.",
          players: 2),
      QuestionData(
          text:
              "🚫 {player1} et {player2}, interdiction de dire oui pendant 2 tours. Chaque erreur = 2.",
          players: 2),
      QuestionData(
          text:
              "🎲 Duo dés : {player1} lance, {player2} boit la moitié du score et invente une raison.",
          players: 2,
          type: QuestionType.dice),
      QuestionData(
          text:
              "🧨 {player1}, donne une question gênante à {player2}. Réponse ou 4 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🏆 {player1} et {player2}, la table vote pour le binôme le plus instable. Perdants boivent 3 chacun.",
          players: 2),
      QuestionData(
          text:
              "🔥 {player1} et {player2}, dites chacun une vérité sur l'autre. La plus molle boit 3.",
          players: 2),
      QuestionData(
          text:
              "🔐 {player1} raconte un secret nul à {player2}. Si {player2} trouve ça triste, il boit 3.",
          players: 2),
      QuestionData(
          text:
              "🎵 {player1} choisit une chanson. {player2} doit donner l'artiste ou chanter le refrain et boire 2.",
          players: 2),
      QuestionData(
          text:
              "👑 {player1} nomme {player2} bras droit du chaos. Vous distribuez 4 gorgées ensemble.",
          players: 2),
      QuestionData(
          text:
              "🪙 {player1} choisit la punition, {player2} choisit la cible : 3 gorgées avec motif absurde.",
          players: 2),
      QuestionData(
          text:
              "🏁 {player1} et {player2}, faux couple en dispute sur une télécommande. Le moins convaincant boit 3.",
          players: 2),
      QuestionData(
          text:
              "📞 {player1} laisse un faux vocal de rupture à {player2}. Si c'est trop propre, vous buvez chacun 2.",
          players: 2),
      QuestionData(
          text:
              "🧽 {player1} et {player2}, inventez une pub pour nettoyer la honte de la soirée. Perdants du cringe boivent 3.",
          players: 2),
      QuestionData(
          text:
              "🍝 {player1} accuse {player2} d'avoir une énergie de plat réchauffé. {player2} répond ou boit 3.",
          players: 2),
      QuestionData(
          text:
              "🛒 {player1} et {player2}, faites semblant de vous disputer au rayon des mauvaises décisions. La table vote.",
          players: 2),
      QuestionData(
          text:
              "🎓 {player1} donne un diplôme honteux à {player2}. S'il refuse la cérémonie, il boit 3.",
          players: 2),
      QuestionData(
          text:
              "🪞 {player1} et {player2}, chacun imite la façon de mentir de l'autre. Le moins drôle boit 3.",
          players: 2),
    ],
    'bar': [
      QuestionData(
          text:
              "🍸 {player1}, invente un cocktail avec un nom honteux. La table note, moins de 7/10 = 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎤 {player1}, fais une annonce de barman comme si le bar était en crise nationale. Si c'est plat, bois 3.",
          players: 1),
      QuestionData(
          text:
              "🥃 {player1}, shot virtuel ou désigne deux joueurs qui doivent commander avec une voix ridicule.",
          players: 1),
      QuestionData(
          text:
              "🍺 Happy comptoir : {player1}, distribue 1 gorgée à chaque personne qui a déjà dit j'arrive alors qu'elle partait.",
          players: 1),
      QuestionData(
          text:
              "🧾 Note du barman : {player1}, choisis le client le plus bruyant. Il boit 3 et baisse d'un ton.",
          players: 1),
      QuestionData(
          text:
              "🎵 Jukebox cassé : {player1}, chante un refrain. Si quelqu'un connaît, il boit 1. Sinon tu bois 3.",
          players: 1),
      QuestionData(
          text:
              "🥂 {player1}, {player2} et {player3}, toast express. Le moins crédible boit 3.",
          players: 3),
      QuestionData(
          text:
              "🚪 {player1}, raconte ta pire entrée quelque part comme si c'était un exploit sportif ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "🪑 Tabouret libre : le dernier debout boit 2 et annonce son licenciement imaginaire.",
          players: 1),
      QuestionData(
          text:
              "🍻 {player1} et {player2}, duel de santé. Le toast le plus nul boit 3.",
          players: 2),
      QuestionData(
          text:
              "🎩 {player1}, fais un tour de magie nul. Si personne ne dit incroyable, bois 3.",
          players: 1),
      QuestionData(
          text:
              "🧃 {player1}, choisis un joueur qui doit parler comme un serveur trop chic pendant 1 tour.",
          players: 1),
      QuestionData(
          text:
              "📣 {player1}, crie un faux nom de cocktail. Ceux qui répètent mal boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🎲 {player1}, lance le dé du comptoir. 1-3 tu bois, 4-6 tu distribues en inventant les factures.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text:
              "🧊 Service frais : {player1}, le joueur avec le verre le plus plein boit 3 parce qu'il manque d'engagement.",
          players: 1),
      QuestionData(
          text:
              "🍷 {player1}, règle de bar : plus personne ne peut dire verre pendant 2 tours. Erreur = 1 gorgée.",
          players: 1),
      QuestionData(
          text:
              "🎭 {player1}, imite le client qui négocie une pinte à crédit ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "💳 {player1}, addition surprise : bois 2 et donne 2 à {player2} pour frais de dossier.",
          players: 2),
      QuestionData(
          text:
              "🚨 Dernier appel : tout le monde boit 1, {player1} choisit qui a l'air déjà fermé.",
          players: 1),
      QuestionData(
          text:
              "🛎️ {player1}, sonne le service imaginaire. Le dernier à répondre patron boit 2.",
          players: 1),
      QuestionData(
          text: "🎰 {player1}, tente le Jackpot du bar.",
          players: 1,
          type: QuestionType.slotMachine),
      QuestionData(
          text:
              "🔥 {player1}, donne un titre de soirée façon documentaire gênant. Si la table refuse, bois 4.",
          players: 1),
      QuestionData(
          text:
              "👥 {player1}, {player2} et {player3}, créez une mini tournée. Chacun donne 2 gorgées avec une excuse débile.",
          players: 3),
      QuestionData(
          text:
              "🏁 Fermeture du bar : le dernier qui dit merci patron boit cul sec.",
          players: 1),
      QuestionData(
          text:
              "🍾 {player1}, annonce une fausse promotion du bar. Si la table n'y croit pas, bois 3.",
          players: 1),
      QuestionData(
          text:
              "🎙️ {player1}, fais le videur pendant 1 tour. Le prochain qui râle boit 3.",
          players: 1),
      QuestionData(
          text:
              "💳 {player1}, choisis un joueur qui a une dette imaginaire. Il boit 4 et remercie la compta.",
          players: 1),
      QuestionData(
          text:
              "🏆 {player1}, nomme le MVP du bar. Il distribue 5 gorgées en conférence de presse.",
          players: 1),
      QuestionData(
          text:
              "🪪 {player1}, contrôle d'identité du bar : choisis quelqu'un qui a une tête à oublier son code PIN. Il boit 3.",
          players: 1),
      QuestionData(
          text:
              "🍽️ {player1}, invente le plat du jour le plus dégoûtant possible. Si la table refuse de commander, bois 3.",
          players: 1),
      QuestionData(
          text:
              "📢 {player1}, annonce que le bar ferme pour cause de malaise social. Le dernier à protester boit 2.",
          players: 1),
      QuestionData(
          text:
              "🎟️ {player1}, donne un ticket VIP imaginaire à {player2}. Il doit faire un discours ou boire 3.",
          players: 2),
      QuestionData(
          text:
              "🧯 {player1}, choisis le joueur qui mettrait le feu à l'ambiance en racontant trop longtemps sa vie. Il boit 4.",
          players: 1),
      QuestionData(
          text:
              "🧾 {player1}, facture de honte : chaque joueur donne une raison de te faire boire. Tu prends les 2 meilleures.",
          players: 1),
    ],
    'chill': [
      QuestionData(
          text:
              "😌 {player1}, raconte ton meilleur souvenir de soirée comme un vieux sage fatigué. Si c'est trop court, bois 1.",
          players: 1),
      QuestionData(
          text:
              "🍔 {player1}, donne ton plat de fin de soirée idéal. Ceux qui jugent boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🎶 {player1}, cite une chanson honteuse que tu aimes. Ceux qui la connaissent boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🛋️ Pause canapé : le dernier installé comme une larve sociale boit 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🤝 {player1}, donne un compliment sincère à {player2}, mais avec une voix de message vocal gênant.",
          players: 2),
      QuestionData(
          text:
              "📸 {player1} et {player2}, prenez une photo sympa mais beaucoup trop sérieuse ou buvez chacun 1.",
          players: 2),
      QuestionData(
          text:
              "🎭 {player1}, mime ton énergie actuelle. {player2} doit deviner ou boire 1.",
          players: 2),
      QuestionData(
          text:
              "🕯️ {player1}, raconte un moment gênant mais mignon. Ceux qui ont pire boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🍿 {player1}, recommande un film. Ceux qui disent je l'ai vu mais ne savent plus l'histoire boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🎧 {player1} et {player2}, trouvez une chanson que vous aimez tous les deux ou buvez chacun 2.",
          players: 2),
      QuestionData(
          text:
              "☕ {player1}, choisis le joueur le plus posé. Il distribue 3 gorgées comme un conseiller municipal.",
          players: 1),
      QuestionData(
          text:
              "🌙 {player1}, raconte une soirée qui a fini trop tard et trop bêtement ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🍪 {player1}, si tu as grignoté depuis le début, bois 1 et distribue 1 avec honte.",
          players: 1),
      QuestionData(
          text:
              "🤫 {player1}, fais deviner ton humeur avec un seul mot nul. Mauvaise réponse = tout le monde boit 1.",
          players: 1),
      QuestionData(
          text:
              "🥂 {player1}, porte un toast gentil à {player2}, mais comme si tu étais à un mariage raté.",
          players: 2),
      QuestionData(
          text:
              "🎲 {player1}, dé chill : 1-2 tu bois 1, 3-4 tu distribues 1, 5-6 tout le monde trinque.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text:
              "🎁 {player1}, offre une immunité d'une gorgée à quelqu'un qui a l'air mentalement en travaux.",
          players: 1),
      QuestionData(
          text:
              "🏁 Fin douce : tout le monde boit 1 et donne une note à l'ambiance comme dans un hôtel.",
          players: 1),
      QuestionData(
          text:
              "🧺 {player1}, raconte une petite honte de vie quotidienne. Ceux qui ont déjà fait pire boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🛌 {player1}, mime ton réveil après une soirée ratée. Si la table compatit, distribue 2.",
          players: 1),
      QuestionData(
          text:
              "📚 {player1}, donne un titre de livre à la soirée. Le titre le plus nul de la table boit 1.",
          players: 1),
      QuestionData(
          text:
              "🧘 {player1}, respire comme quelqu'un qui a tout compris à la vie. Si tu ris, bois 1.",
          players: 1),
      QuestionData(
          text:
              "🎨 {player1}, décris {player2} en trois couleurs absurdes. {player2} choisit qui boit 1.",
          players: 2),
      QuestionData(
          text:
              "🧁 {player1}, donne un compliment beaucoup trop spécifique à quelqu'un. S'il rougit, il boit 1.",
          players: 1),
      QuestionData(
          text:
              "🪩 {player1}, raconte ton meilleur faux souvenir de boîte de nuit. La table décide si tu bois 2.",
          players: 1),
      QuestionData(
          text:
              "🧦 {player1}, ceux qui ont déjà dormi habillés après une soirée boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🫶 {player1}, sauve quelqu'un d'une gorgée en lui donnant un conseil nul.",
          players: 1),
      QuestionData(
          text:
              "🏖️ {player1}, raconte une excuse de vacances inventée. Si on y croit, distribue 2.",
          players: 1),
    ],
    'hot': [
      QuestionData(
          text:
              "🔥 {player1}, donne ton red flag en flirt comme si tu vendais un produit nul ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "💋 {player1}, raconte ton pire message de drague en mode lecture dramatique ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "😏 {player1}, donne une note de flirt à {player2}. Si c'est lâche, bois 3.",
          players: 2),
      QuestionData(
          text:
              "🕯️ {player1} et {player2}, regard intense 15 secondes. Le premier qui sourit boit 3.",
          players: 2),
      QuestionData(
          text:
              "📱 {player1}, décris ton dernier message ambigu sans nommer la personne ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "🍑 {player1}, cite ton type physique en version beaucoup trop précise ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "🫦 {player1}, avoue une phrase de drague qui marche sur toi ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "💌 {player1}, qui ici aurait le plus de chance de te séduire en parlant seulement de météo ? Réponds ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "🔥 {player1}, raconte ton date le plus gênant comme un fait divers ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "💬 {player1}, {player2} te pose une question flirt. Réponse ou 3 gorgées.",
          players: 2),
      QuestionData(
          text:
              "👀 {player1}, qui ici a le regard le plus dangereux ? Cette personne boit 2 et assume.",
          players: 1),
      QuestionData(
          text: "🧨 {player1}, avoue ton pire faux pas en date ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "💄 {player1}, choisis le meilleur profil dating app de la table. Il distribue 3.",
          players: 1),
      QuestionData(
          text:
              "🎭 {player1}, joue une scène de flirt catastrophique. Si la table rit, distribue 3.",
          players: 1),
      QuestionData(
          text:
              "🔒 {player1}, secret hot soft : réponds à qui t'intimide le plus ici ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "🥂 {player1}, choisis un duo qui aurait une bonne alchimie. Ils boivent 2 chacun.",
          players: 1),
      QuestionData(
          text:
              "📸 {player1}, décris ta photo de profil idéale comme si tu étais ton propre agent ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🏁 {player1}, dernière tension : donne ton avis le plus honnête sur le charme de la table ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "🧾 {player1}, fais le bilan de ton historique de flirt comme un comptable triste ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "💅 {player1}, qui ici aurait le meilleur profil de dragueur raté mais attachant ? Il boit 2.",
          players: 1),
      QuestionData(
          text:
              "📞 {player1}, invente un message vocal de lendemain de date catastrophique ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "🍓 {player1}, donne la phrase de flirt la plus gênante possible à {player2}. S'il rit, il boit 2.",
          players: 2),
      QuestionData(
          text:
              "🪞 {player1}, avoue ton plus gros défaut quand tu veux plaire ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "🎬 {player1}, joue la scène où tu essaies d'être mystérieux et tu échoues. Si c'est trop vrai, bois 3.",
          players: 1),
      QuestionData(
          text:
              "🧨 {player1}, dis qui ici pourrait te faire perdre tes moyens avec une seule phrase. Réponse ou 4.",
          players: 1),
      QuestionData(
          text:
              "💬 {player1}, donne ton pire conseil de séduction. La table choisit qui boit 3.",
          players: 1),
      QuestionData(
          text:
              "🕯️ {player1} et {player2}, faux dîner romantique en 15 secondes. Le moins investi boit 3.",
          players: 2),
      QuestionData(
          text:
              "🔥 {player1}, qui ici serait le plus dangereux en date parce qu'il parle trop ? Il boit 3.",
          players: 1),
    ],
    'express': [
      QuestionData(
          text: "⚡ {player1}, cite 3 excuses nulles en 5 secondes ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🏃 {player1}, touche un mur et reviens. Le dernier assis boit 2.",
          players: 1),
      QuestionData(
          text: "📢 Le dernier qui crie TCHIN boit 3 gorgées.", players: 1),
      QuestionData(
          text:
              "🍺 {player1}, bois 2 gorgées le plus vite possible, mais avec dignité.",
          players: 1),
      QuestionData(
          text: "🤚 Le dernier qui lève la main boit 2 gorgées.", players: 1),
      QuestionData(
          text: "🧱 {player1}, touche un objet rouge en 3 secondes ou bois 2.",
          players: 1),
      QuestionData(
          text: "⏱️ {player1}, cite 4 villes en 6 secondes ou bois 3.",
          players: 1),
      QuestionData(
          text: "⚡ Tout le monde main sur la tête. Le dernier boit 2.",
          players: 1),
      QuestionData(
          text:
              "🚀 {player1}, fais rire {player2} en 10 secondes. Perdant boit 2.",
          players: 2),
      QuestionData(
          text:
              "🎲 {player1}, dé express : pair tu bois 2, impair tu distribues 2.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text: "📱 Tout le monde cache son téléphone. Le dernier boit 2.",
          players: 1),
      QuestionData(
          text: "🪑 Tout le monde debout puis assis. Le dernier boit 2.",
          players: 1),
      QuestionData(
          text:
              "🗣️ {player1}, dis une phrase sans la lettre A. Erreur = 2 gorgées.",
          players: 1),
      QuestionData(
          text: "🎵 Le dernier qui fredonne quelque chose boit 2 gorgées.",
          players: 1),
      QuestionData(
          text: "📣 {player1}, dis santé dans 3 langues ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "🏁 Flash : {player1}, donne 1 gorgée à deux personnes en moins de 5 secondes.",
          players: 1),
      QuestionData(
          text:
              "⚡ {player1}, cite 3 choses qu'on regrette à 3h du matin en 5 secondes ou bois 2.",
          players: 1),
      QuestionData(
          text: "🎤 Dernier à dire je suis une erreur administrative boit 2.",
          players: 1),
      QuestionData(
          text:
              "🧠 {player1}, cite 4 excuses pour partir sans dire au revoir ou bois 3.",
          players: 1),
      QuestionData(
          text: "📣 Tout le monde dit santé patron. Le dernier boit 2.",
          players: 1),
      QuestionData(
          text: "🧦 {player1}, trouve un objet mou en 5 secondes ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🚀 {player1}, donne un surnom nul à {player2} en 3 secondes ou bois 2.",
          players: 2),
      QuestionData(
          text:
              "🎲 {player1}, lance le dé express honteux. Si tu fais 1, cul sec symbolique = 5 gorgées.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(text: "🪑 Dernier à toucher sa chaise boit 2.", players: 1),
      QuestionData(
          text:
              "🥤 {player1}, cite 3 boissons décevantes en 4 secondes ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🏁 Turbo honte : {player1}, distribue 3 gorgées avant que la table compte à 5.",
          players: 1),
    ],
    'borderline': [
      QuestionData(
          text:
              "💀 {player1}, si tes DM passaient sur écran géant, quel serait le titre du scandale ? Réponse ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "⚖️ Procès de la honte : {player1}, la table t'accuse d'être le plus gros danger en after. Défends-toi en 20 secondes ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "💊 {player1}, raconte une anecdote de drogue ou d'after illégal sans donner de nom. Refus = 6 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🔞 {player1}, quelle est la pire chose que tu as faite par désir et que tu regrettes vraiment ? Réponse ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "🥀 {player1}, as-tu déjà trompé quelqu'un ou couvert quelqu'un qui trompait ? Réponse ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "☠️ {player1}, qui ici finirait le plus probablement dans un scandale de groupe WhatsApp ? Il boit 4 et se justifie.",
          players: 1),
      QuestionData(
          text:
              "👻 {player1}, as-tu déjà ghosté quelqu'un après lui avoir fait croire que c'était sérieux ? Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "🖤 {player1}, donne ton fantasme le plus tabou en version non détaillée ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "📱 Choix impossible : {player1}, tu préfères que tes parents lisent tes DM ou que ton ex voie ton historique de recherche ? Explique ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "🤥 {player1}, raconte le mensonge le plus sale que tu as dit pour séduire, fuir ou obtenir quelque chose. Refus = cul sec.",
          players: 1),
      QuestionData(
          text:
              "💸 {player1}, as-tu déjà menti sur l'argent, une dette ou un paiement ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "🧾 {player1}, la table choisit ton procès : sexe, drogue, argent ou mensonge. Tu réponds ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "💬 {player1}, donne le type de message qui te ferait supprimer toute une conversation ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "🧠 {player1}, qui ici a le plus gros ego sexuel selon toi ? Cette personne boit 4 et peut nier en public.",
          players: 1),
      QuestionData(
          text:
              "👀 {player1}, as-tu déjà voulu quelqu'un déjà pris ? Réponse ou 5 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🚫 {player1}, cite une limite morale que tu as déjà franchie en soirée ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "🔥 Balance quelqu'un : qui ici serait le plus capable de mentir pour coucher avec quelqu'un ? Il boit 5 et plaide coupable ou innocent.",
          players: 1),
      QuestionData(
          text:
              "🕳️ {player1}, quelle recherche internet te ferait le plus honte ici ? Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "🧪 {player1}, as-tu déjà mélangé alcool et substance ? Raconte la conséquence ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "💔 {player1}, as-tu déjà couché avec quelqu'un par ego, vengeance ou ennui ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "😈 {player1}, choisis sexe, drogue ou mensonge. La table pose une question sur le thème. Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "🧨 {player1}, {player2} te pose une question sexuelle directe mais non graphique. Réponds ou bois 5.",
          players: 2),
      QuestionData(
          text:
              "⚔️ {player1} et {player2}, chacun donne une vérité sale sur l'autre. Celui qui refuse boit cul sec.",
          players: 2),
      QuestionData(
          text:
              "💀 {player1}, qui ici serait le pire coup d'un soir ? Réponds ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "🔞 {player1}, raconte ton plus gros regret sexuel sans détail graphique ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "📸 {player1}, as-tu déjà gardé une photo compromettante trop longtemps ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "🧯 {player1}, quelle rumeur sur toi serait la plus crédible ? Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "👁️ {player1}, qui ici aurait les DM les plus dangereux à lire ? Il ou elle boit 4.",
          players: 1),
      QuestionData(
          text:
              "💊 {player1}, raconte une fois où quelqu'un a trop abusé en soirée. Refus = 5.",
          players: 1),
      QuestionData(
          text:
              "⚖️ Tribunal du bar : {player1} est accusé d'avoir déjà été une mauvaise fréquentation. La table donne une preuve ou boit 2 chacun.",
          players: 1),
      QuestionData(
          text:
              "🧨 Choix impossible : {player1}, tu préfères révéler ton pire mensonge amoureux ou ta pire honte d'argent ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "☠️ {player1}, quelle est la pire trahison que tu as faite ou subie ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "🔥 {player1}, {player2} devine ton plus gros vice. S'il a tort, il boit 4, sinon tu bois 4.",
          players: 2),
      QuestionData(
          text:
              "🧾 Addition noire : {player1}, raconte une vérité que tu n'assumes pas ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "📱 {player1}, si on ouvrait ton téléphone 30 secondes, quelle appli ferait le plus de dégâts ? Réponse ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "💥 {player1}, as-tu déjà fait quelque chose d'illégal pour impressionner quelqu'un ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "🧊 {player1}, la table choisit une question taboue. Tu réponds ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "🖕 {player1}, qui ici a le comportement le plus toxique en relation ? Cette personne boit 4.",
          players: 1),
      QuestionData(
          text:
              "🤐 {player1}, avoue une chose que ton téléphone pourrait ruiner s'il était projeté au mur. Refus = cul sec.",
          players: 1),
      QuestionData(
          text:
              "💉 {player1}, as-tu déjà caché une consommation à quelqu'un ? Raconte ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "🫦 {player1}, quelle personne ici te mettrait le plus mal à l'aise en flirtant ? Réponds ou shot.",
          players: 1),
      QuestionData(
          text:
              "⚡ {player1}, {player2} et {player3}, votez pour le plus borderline. Il boit cul sec et doit accepter le verdict.",
          players: 3),
      QuestionData(
          text:
              "🧨 {player1}, raconte ta pire décision prise après 2h du matin ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "💀 Vérité sale : {player1}, quelle est la chose que tu as faite en soirée et que tu n'aurais jamais racontée sobre ? Réponse ou 7.",
          players: 1),
      QuestionData(
          text:
              "🏁 Pacte noir : {player1}, choisis quelqu'un qui doit répondre à une question taboue ou boire cul sec.",
          players: 1),
      QuestionData(
          text:
              "🧨 {player1}, avoue la fois où tu as été le plus pathétique par désir ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "💊 {player1}, quelle soirée a failli devenir un vrai problème à cause d'une consommation ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "💣 Balance quelqu'un : qui ici pourrait détruire un couple juste par ennui ? Il boit 4 et peut contre-attaquer.",
          players: 1),
      QuestionData(
          text:
              "🔞 {player1}, as-tu déjà eu honte juste après un moment intime ? Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "💣 {player1}, qui ici mentirait le mieux à son partenaire ? Il boit 4 et peut accuser quelqu'un.",
          players: 1),
      QuestionData(
          text:
              "🕳️ {player1}, quelle partie de ton historique internet mérite un avocat ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "⚖️ Procès express : {player1}, {player2} choisit ton chef d'accusation entre sexe, drogue ou mensonge. Tu réponds ou shot.",
          players: 2),
      QuestionData(
          text:
              "🥀 {player1}, as-tu déjà gardé quelqu'un sous le coude juste pour ton ego ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "🔥 {player1}, quel flirt te ferait perdre toute crédibilité devant la table ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "🧾 {player1}, facture de l'enfer : raconte une dette morale que tu dois à quelqu'un ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "💔 {player1}, as-tu déjà fait semblant d'être attaché pour obtenir quelque chose ? Réponse ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "⚔️ Duel sale : {player1} et {player2}, chacun choisit pour l'autre une catégorie entre sexe, drogue, argent ou mensonge. Réponse ou 5.",
          players: 2),
      QuestionData(
          text:
              "🧨 {player1}, raconte ton plus gros mensonge de fin de soirée ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "💊 {player1}, as-tu déjà minimisé une consommation pour ne pas inquiéter quelqu'un ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "🔞 {player1}, quelle est la question sexuelle que tu redoutes le plus ici ? La table peut la poser ou tu bois 6.",
          players: 1),
      QuestionData(
          text:
              "📱 {player1}, quel contact ne doit jamais voir ton état ce soir ? Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "💸 {player1}, as-tu déjà dépensé une somme honteuse pour impressionner quelqu'un ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "🕳️ {player1}, avoue une pensée jalouse vraiment sale ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "🔥 {player1}, qui ici pourrait te faire prendre une décision regrettable ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "☠️ {player1}, quel est le pire truc que tu as déjà couvert pour un pote ? Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "🧾 {player1}, crée ton dossier judiciaire imaginaire : une accusation sexe, une accusation mensonge, une accusation soirée. Si c'est nul, bois 6.",
          players: 1),
      QuestionData(
          text:
              "💬 {player1}, quel message de toi pourrait faire dire à la table ah ouais t'es dangereux ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "😈 {player1}, fais boire 5 gorgées à la personne qui cache le plus gros dossier selon toi.",
          players: 1),
      QuestionData(
          text:
              "⚔️ {player1}, {player2} choisit entre ta pire honte sexuelle ou ta pire honte d'argent. Réponse ou shot.",
          players: 2),
      QuestionData(
          text:
              "🏁 Verdict noir : {player1}, la table te pose une dernière question sans filtre. Réponse ou 7 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎭 {player1}, qui ici aurait le plus gros dossier si son ex parlait ? Cette personne boit 4 et donne le titre du dossier.",
          players: 1),
      QuestionData(
          text:
              "🧨 Choix impossible : {player1}, tu préfères avouer ton pire DM à ton crush ou ta pire soirée à ta famille ? Choisis ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "⚖️ La table juge {player1} : toxique par jalousie, par désir ou par ego ? Verdict majoritaire = 5 gorgées.",
          players: 1),
      QuestionData(
          text:
              "💬 {player1}, donne la phrase la plus manipulatrice qu'on pourrait t'entendre dire. Refus = cul sec.",
          players: 1),
      QuestionData(
          text:
              "☠️ {player1}, qui ici ferait le plus confiance à la mauvaise personne pour un plan foireux ? Il boit 4 et accuse quelqu'un.",
          players: 1),
      QuestionData(
          text:
              "🕳️ {player1}, raconte une fois où tu as joué double jeu. Pas de noms, mais assez pour que la table comprenne ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "🔞 {player1}, quelle vérité sexuelle ferait changer l'ambiance si tu la disais maintenant ? Réponse soft ou 7 gorgées.",
          players: 1),
      QuestionData(
          text:
              "💊 {player1}, quelle règle de soirée tu as déjà ignorée alors que tu savais que c'était une mauvaise idée ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "🍷 Le verre du milieu... La table choisit le thème interdit avant de le lancer.",
          players: 1,
          type: QuestionType.centralGlass),
    ],
  };
}
