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
          text: "🍻 {player1}, distribue 4 gorgées à la table.", players: 1),
      QuestionData(
          text:
              "🎤 {player1}, lance un refrain. Ceux qui ne chantent pas boivent 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "👑 {player1}, tu deviens patron du bar pendant 1 tour. Toute contestation vaut 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🧾 {player1}, choisis le client du soir. Il boit 3 gorgées et peut en redistribuer 1.",
          players: 1),
      QuestionData(
          text:
              "🍺 {player1}, bois 2 gorgées puis invente un toast que tout le monde répète.",
          players: 1),
      QuestionData(
          text:
              "🎲 {player1}, lance un dé. Tu bois la moitié du score arrondi au dessus.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text:
              "🪙 {player1}, pile tu distribues 5 gorgées, face tu bois 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🚨 Tout le monde pose son verre. Le dernier à le faire boit 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎭 {player1}, imite {player2}. Si la table devine, {player2} boit 2 gorgées, sinon tu bois.",
          players: 2),
      QuestionData(
          text:
              "🤝 {player1}, fais un compliment honnête à {player2}. Les deux trinquent.",
          players: 2),
      QuestionData(
          text:
              "🃏 {player1}, choisis une règle simple valable jusqu'à ton prochain tour.",
          players: 1),
      QuestionData(
          text:
              "🍸 {player1}, cite 3 cocktails en 10 secondes ou bois 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "📸 {player1} et {player2}, prenez une photo de table ou buvez chacun 2 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🎯 {player1}, désigne la personne la plus en forme ce soir. Elle distribue 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🥂 {player1}, {player2} et {player3}, trinquez ensemble. Le dernier verre levé boit 2 gorgées.",
          players: 3),
      QuestionData(
          text: "🧠 {player1}, raconte une anecdote drôle ou bois 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🚫 {player1}, tu n'as plus le droit de dire le prénom de {player2} pendant 2 tours.",
          players: 2),
      QuestionData(
          text: "🕺 {player1}, fais 5 secondes de danse ou bois 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🍟 {player1}, celui qui a mangé le plus récemment boit 2 gorgées avec toi.",
          players: 1),
      QuestionData(
          text:
              "🧊 {player1}, garde ton sérieux pendant 15 secondes. Si tu ris, bois 2 gorgées.",
          players: 1),
      QuestionData(
          text: "🎡 {player1}, tourne la Roue de la Fortune.",
          players: 1,
          type: QuestionType.wheel),
      QuestionData(
          text: "Morpion ! ❌⭕ {player1} défie quelqu'un en 1v1.",
          players: 1,
          type: QuestionType.ticTacToe),
      QuestionData(
          text: "🎰 {player1}, tente le Jackpot du comptoir.",
          players: 1,
          type: QuestionType.slotMachine),
      QuestionData(
          text: "🔁 {player1}, échange ta prochaine pénalité avec {player2}.",
          players: 2),
      QuestionData(
          text:
              "🏁 Dernier service soft : tout le monde boit 1 gorgée, {player1} en distribue 2.",
          players: 1),
      QuestionData(
          text:
              "🧢 {player1}, invente un surnom de soirée pour {player2}. S'il refuse, il boit 2.",
          players: 2),
      QuestionData(
          text:
              "🍋 {player1}, cite 3 choses jaunes en 8 secondes ou bois 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🕰️ {player1}, le joueur arrivé le plus tard boit 2 gorgées avec toi.",
          players: 1),
      QuestionData(
          text:
              "📣 {player1}, fais une annonce officielle de soirée ou bois 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🔄 {player1}, inverse le sens de jeu et donne 1 gorgée au joueur suivant.",
          players: 1),
      QuestionData(
          text: "👟 {player1}, ceux qui portent des baskets boivent 1 gorgée.",
          players: 1),
      QuestionData(
          text:
              "🧩 {player1}, fais deviner un film sans parler. Échec = 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🥇 {player1}, la table vote pour le meilleur rire. Le gagnant distribue 3.",
          players: 1),
      QuestionData(
          text:
              "🍹 {player1}, choisis un joueur qui doit parler avec un accent pendant 1 tour.",
          players: 1),
      QuestionData(
          text: "🎁 {player1}, offre une immunité d'une gorgée à {player2}.",
          players: 2),
    ],
    'hard': [
      QuestionData(
          text: "🔥 {player1}, raconte une vérité gênante ou bois 4 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🥃 {player1}, cul sec ou distribue 7 gorgées en regardant les joueurs dans les yeux.",
          players: 1),
      QuestionData(
          text:
              "🧨 {player1}, la table vote : tu bois 5 gorgées ou {player2} en boit 4.",
          players: 2),
      QuestionData(
          text:
              "👀 {player1}, dis le plus gros défaut de soirée de {player2} ou bois 4 gorgées.",
          players: 2),
      QuestionData(
          text:
              "📱 {player1}, montre ta dernière photo enregistrée ou bois 5 gorgées.",
          players: 1),
      QuestionData(
          text:
              "⚖️ Tribunal du bar : {player1}, {player2} et {player3} votent pour le pire menteur. Il boit 4 gorgées.",
          players: 3),
      QuestionData(
          text:
              "🎯 {player1}, désigne la personne qui va craquer en premier ce soir. Elle boit 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🚫 {player1}, mot interdit : choisis un mot courant. Chaque erreur vaut 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🧊 {player1}, garde un visage neutre pendant que la table te provoque 20 secondes ou bois 3.",
          players: 1),
      QuestionData(
          text: "🍺 {player1}, bois 1 gorgée par joueur autour de la table.",
          players: 1),
      QuestionData(
          text:
              "🧾 Addition salée : {player1}, choisis quelqu'un qui prend 3 gorgées maintenant et 2 au prochain tour.",
          players: 1),
      QuestionData(
          text:
              "💥 Carte choc : {player1}, accepte la prochaine pénalité sans négocier ou bois 6 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🥶 {player1}, avoue un message que tu regrettes ou bois 4 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🗣️ {player1}, laisse {player2} te poser une question directe. Réponds ou bois 5.",
          players: 2),
      QuestionData(
          text:
              "🍻 {player1} et {player2}, duel de regard. Le premier qui rit boit 4 gorgées.",
          players: 2),
      QuestionData(
          text: "🪑 Tout le monde se lève. Le dernier assis boit 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "👑 {player1}, donne un ordre de table. Celui qui refuse boit 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎲 {player1}, lance le dé : pair tu distribues le score, impair tu le bois.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text:
              "🕯️ {player1}, confession du comptoir : raconte ta pire excuse ou bois 4 gorgées.",
          players: 1),
      QuestionData(
          text:
              "😬 {player1}, choisis : appeler quelqu'un par un surnom humiliant pendant 2 tours ou boire 5.",
          players: 1),
      QuestionData(
          text:
              "🔒 {player1}, ne touche plus ton verre jusqu'à ton prochain tour. Si tu oublies, cul sec.",
          players: 1),
      QuestionData(
          text:
              "🧃 {player1}, mélange deux boissons non dangereuses. Tu bois 3 gorgées du résultat.",
          players: 1),
      QuestionData(
          text:
              "🚨 {player1}, la table choisit un défi vocal. Si tu refuses, shot.",
          players: 1),
      QuestionData(
          text:
              "🃏 {player1}, pioche mentale : choisis un joueur qui perd son prochain droit de réponse.",
          players: 1),
      QuestionData(
          text:
              "🏁 Dernier avertissement : {player1}, bois 6 gorgées ou donne 2 gorgées à trois joueurs.",
          players: 1),
      QuestionData(
          text:
              "🪓 {player1}, coupe la parole au prochain joueur. S'il proteste, il boit 3.",
          players: 1),
      QuestionData(
          text:
              "🧯 {player1}, raconte ta pire tentative de sauver une soirée ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "📵 {player1}, pose ton téléphone face visible jusqu'à ton prochain tour ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "🎭 {player1}, fais semblant de plaider coupable devant la table. Mauvaise prestation = 4 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🧠 {player1}, cite une mauvaise décision récente ou bois 5 gorgées.",
          players: 1),
      QuestionData(
          text:
              "⚡ {player1}, {player2} choisit un mot. Si tu l'utilises avant 2 tours, cul sec.",
          players: 2),
      QuestionData(
          text:
              "🥃 {player1}, shot ou donne une vérité gênante sur ton dernier week-end.",
          players: 1),
      QuestionData(
          text:
              "🚪 {player1}, sors de la pièce 5 secondes. La table décide entre 2 et 6 gorgées pour toi.",
          players: 1),
      QuestionData(
          text:
              "💬 {player1}, laisse {player2} choisir une question oui/non. Si tu mens, 6 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🧾 {player1}, addition punitive : bois 3 maintenant, puis 1 à ton prochain tour.",
          players: 1),
      QuestionData(
          text:
              "🔁 {player1}, échange ton verre de main jusqu'à ton prochain tour. Erreur = 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🏴 {player1}, désigne le joueur le plus fourbe. Il boit 4 et peut en rendre 1.",
          players: 1),
    ],
    'duo': [
      QuestionData(
          text:
              "👥 {player1} et {player2}, buvez 3 gorgées en même temps sans vous regarder.",
          players: 2),
      QuestionData(
          text:
              "🎭 {player1} raconte une histoire fausse. {player2} a 20 secondes pour trouver le mensonge. Le perdant boit 3.",
          players: 2),
      QuestionData(
          text:
              "🤝 {player1} et {player2}, pacte de verre : si l'un boit au prochain tour, l'autre boit 1.",
          players: 2),
      QuestionData(
          text:
              "👀 {player1} et {player2}, duel de regard. Le premier qui cligne exagérément boit 2.",
          players: 2),
      QuestionData(
          text:
              "🎤 {player1} chante une phrase, {player2} doit continuer. Échec = 2 gorgées chacun.",
          players: 2),
      QuestionData(
          text:
              "🧠 {player1}, devine le dernier achat inutile de {player2}. Mauvaise réponse = 2 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🍺 {player1} et {player2}, inventez un geste secret. Celui qui l'oublie avant votre prochain tour boit 2.",
          players: 2),
      QuestionData(
          text:
              "📸 {player1} et {player2}, refaites une pose de photo de soirée gênante ou buvez chacun 2.",
          players: 2),
      QuestionData(
          text:
              "🧾 Duo de caisse : {player1} donne 2 gorgées à {player2}, puis {player2} en redistribue 2.",
          players: 2),
      QuestionData(
          text:
              "🎯 {player1} défie {player2} sur une question de culture générale. Le perdant boit 3.",
          players: 2),
      QuestionData(
          text:
              "🥂 {player1} et {player2}, trinquez sans parler. Le premier qui parle boit 2.",
          players: 2),
      QuestionData(
          text:
              "🔁 {player1} et {player2}, échangez vos rôles de prochaine pénalité.",
          players: 2),
      QuestionData(
          text:
              "😏 {player1}, donne une qualité et un défaut de {player2}. Si la table trouve ça faux, tu bois 3.",
          players: 2),
      QuestionData(
          text:
              "🪙 {player1} choisit pile ou face. {player2} lance. Perdant boit 3 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🧊 {player1} et {player2}, restez sérieux 15 secondes. Ceux qui rient boivent 2.",
          players: 2),
      QuestionData(
          text:
              "💬 {player1}, envoie un compliment honnête à {player2} à voix haute ou bois 2.",
          players: 2),
      QuestionData(
          text:
              "🍻 {player1} et {player2}, chacun choisit une personne qui boit 2 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🚫 {player1} et {player2}, vous ne pouvez plus dire oui pendant 2 tours.",
          players: 2),
      QuestionData(
          text:
              "🎲 Duo dés : {player1} lance, {player2} boit la moitié du score.",
          players: 2,
          type: QuestionType.dice),
      QuestionData(
          text:
              "🧨 {player1} choisit une question embarrassante pour {player2}. Réponse ou 4 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🏆 {player1} et {player2}, la table vote pour le meilleur binôme. Les autres boivent 1.",
          players: 2),
      QuestionData(
          text:
              "🔥 {player1} et {player2}, duel final : le premier qui touche son téléphone boit cul sec.",
          players: 2),
      QuestionData(
          text:
              "🔐 {player1} donne un secret soft à {player2}. Si {player2} rit, il boit 3.",
          players: 2),
      QuestionData(
          text:
              "🧾 {player1} et {player2}, addition commune : chacun boit 2 puis donne 1 à quelqu'un.",
          players: 2),
      QuestionData(
          text:
              "🎵 {player1} choisit une chanson. {player2} doit donner l'artiste ou boire 3.",
          players: 2),
      QuestionData(
          text:
              "👑 {player1} nomme {player2} bras droit. Vous distribuez 4 gorgées ensemble.",
          players: 2),
      QuestionData(
          text:
              "🧊 {player1} et {player2}, poignée de main inventée en 10 secondes ou 2 gorgées chacun.",
          players: 2),
      QuestionData(
          text:
              "🍻 {player1} boit 2, {player2} doit trouver une excuse crédible. Mauvaise excuse = 2 aussi.",
          players: 2),
      QuestionData(
          text:
              "🎯 {player1}, prédis le score du prochain dé de {player2}. Mauvais = tu bois 2, bon = il boit 3.",
          players: 2,
          type: QuestionType.dice),
      QuestionData(
          text:
              "📸 {player1} décrit une photo imaginaire de {player2}. Si la table valide, {player2} boit 2.",
          players: 2),
      QuestionData(
          text:
              "🪙 {player1} choisit la punition, {player2} choisit la cible : 3 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🔥 {player1} et {player2}, dites chacun une vérité sur l'autre. La plus faible boit 3.",
          players: 2),
    ],
    'bar': [
      QuestionData(
          text:
              "🍸 {player1}, invente un cocktail ridicule et donne-lui un nom. Échec = 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎤 {player1}, fais une annonce de barman à la table ou bois 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🥃 {player1}, shot ou désigne deux joueurs qui boivent 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🍺 Happy comptoir : {player1}, distribue 1 gorgée à chaque personne qui a déjà commandé ce soir.",
          players: 1),
      QuestionData(
          text:
              "🧾 Note du barman : {player1}, choisis le client le plus bruyant. Il boit 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎵 Jukebox : {player1}, lance un refrain. Si personne ne continue, tout le monde boit 2.",
          players: 1),
      QuestionData(
          text:
              "🥂 {player1}, {player2} et {player3}, toast express. Le moins convaincant boit 3.",
          players: 3),
      QuestionData(
          text:
              "🚪 {player1}, raconte ta pire entrée en soirée ou bois 3 gorgées.",
          players: 1),
      QuestionData(
          text: "🪑 Tabouret libre : le dernier joueur debout boit 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🍻 {player1} et {player2}, duel de cheers. La table choisit le gagnant, perdant boit 3.",
          players: 2),
      QuestionData(
          text:
              "🎩 {player1}, fais un tour de magie nul. Si personne ne rigole, bois 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🧃 {player1}, choisis un joueur qui doit parler comme un serveur chic pendant 1 tour.",
          players: 1),
      QuestionData(
          text:
              "📣 {player1}, crie un faux nom de cocktail. Ceux qui répètent mal boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🎲 {player1}, lance le dé du comptoir. Score 1-3 = tu bois, 4-6 = tu distribues.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text:
              "🧊 Service frais : {player1}, le joueur avec le verre le plus plein boit 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🍷 {player1}, choisis une règle de bar : pas de téléphone, pas de prénom ou pas de gros mots pendant 2 tours.",
          players: 1),
      QuestionData(
          text: "🎭 {player1}, imite le client relou du bar ou bois 4 gorgées.",
          players: 1),
      QuestionData(
          text:
              "💳 {player1}, addition surprise : bois 2 gorgées et donne 2 gorgées à {player2}.",
          players: 2),
      QuestionData(
          text:
              "🚨 Dernier appel : tout le monde boit 1 gorgée, {player1} choisit qui en prend 2 de plus.",
          players: 1),
      QuestionData(
          text:
              "🛎️ {player1}, sonne le service imaginaire. Le dernier à répondre santé boit 2.",
          players: 1),
      QuestionData(
          text: "🎰 {player1}, tente le Jackpot du bar.",
          players: 1,
          type: QuestionType.slotMachine),
      QuestionData(
          text:
              "🔥 {player1}, donne le titre de la soirée. Si la table refuse, bois 4 gorgées.",
          players: 1),
      QuestionData(
          text:
              "👥 {player1}, {player2} et {player3}, créez une mini tournée. Chacun donne 2 gorgées à quelqu'un.",
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
              "🧃 {player1}, choisis le joueur qui commande toujours le plus bizarre. Il boit 2.",
          players: 1),
      QuestionData(
          text:
              "🎙️ {player1}, fais le videur pendant 1 tour. Le prochain qui râle boit 3.",
          players: 1),
      QuestionData(
          text:
              "🍸 {player1}, donne un nom de cocktail à {player2}. S'il est nul, tu bois 3.",
          players: 2),
      QuestionData(
          text:
              "🧾 {player1}, la note tombe : le joueur à ta droite boit 2 et distribue 1.",
          players: 1),
      QuestionData(
          text:
              "🎵 {player1}, choisis une chanson de fermeture. Si personne ne la connaît, bois 4.",
          players: 1),
      QuestionData(
          text:
              "🥃 {player1}, raconte ton pire shot ou prends 1 shot virtuel = 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🚬 {player1}, pause comptoir : ceux qui ont quitté la table depuis le début boivent 2.",
          players: 1),
      QuestionData(
          text:
              "🍻 {player1}, {player2} et {player3}, chacun donne une règle de bar. La table garde la meilleure.",
          players: 3),
      QuestionData(
          text:
              "🛎️ {player1}, service raté : le dernier qui tape deux fois sur la table boit 2.",
          players: 1),
      QuestionData(
          text:
              "💳 {player1}, choisis un joueur qui a une dette imaginaire. Il boit 4.",
          players: 1),
      QuestionData(
          text: "🏆 {player1}, nomme le MVP du bar. Il distribue 5 gorgées.",
          players: 1),
    ],
    'chill': [
      QuestionData(
          text:
              "😌 {player1}, raconte ton meilleur souvenir de soirée. Ceux qui sourient boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🍔 {player1}, donne ton plat de fin de soirée idéal. Ceux qui valident trinquent.",
          players: 1),
      QuestionData(
          text:
              "🎶 {player1}, cite une chanson honteuse que tu aimes. Ceux qui la connaissent boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🛋️ Pause canapé : le dernier installé confortablement boit 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🤝 {player1}, donne un compliment sincère à {player2}. Les deux boivent 1.",
          players: 2),
      QuestionData(
          text:
              "📸 {player1} et {player2}, prenez une photo sympa ou buvez chacun 1.",
          players: 2),
      QuestionData(
          text:
              "🎭 {player1}, mime une habitude de soirée. {player2} doit deviner.",
          players: 2),
      QuestionData(
          text:
              "🕯️ {player1}, raconte un petit moment gênant mais drôle. Ceux qui ont vécu pareil boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🍿 {player1}, recommande un film. Ceux qui ne l'ont jamais vu boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🎧 {player1} et {player2}, trouvez une chanson que vous aimez tous les deux ou buvez chacun 2.",
          players: 2),
      QuestionData(
          text:
              "☕ {player1}, choisis le joueur le plus posé. Il distribue 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🌙 {player1}, raconte une soirée qui a fini beaucoup trop tard ou bois 2.",
          players: 1),
      QuestionData(
          text: "🧠 {player1}, donne une anecdote que personne ici ne connaît.",
          players: 1),
      QuestionData(
          text:
              "🍪 {player1}, si tu as grignoté depuis le début, bois 1 et distribue 1.",
          players: 1),
      QuestionData(
          text:
              "🤫 {player1}, fais deviner ton humeur avec un seul mot. Mauvaise réponse de la table = tout le monde boit 1.",
          players: 1),
      QuestionData(
          text: "🥂 {player1}, porte un toast gentil à {player2}.", players: 2),
      QuestionData(
          text:
              "🎲 {player1}, lance le dé chill : 1-2 tu bois 1, 3-4 tu distribues 1, 5-6 tout le monde trinque.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text:
              "🧊 {player1}, cite une qualité cachée de la personne à ta gauche.",
          players: 1),
      QuestionData(
          text: "🎁 {player1}, offre une immunité d'une gorgée à quelqu'un.",
          players: 1),
      QuestionData(
          text:
              "🏁 Fin douce : tout le monde boit 1 gorgée et dit son meilleur moment de la partie.",
          players: 1),
      QuestionData(
          text:
              "🌤️ {player1}, raconte un petit plaisir honteux. Ceux qui partagent boivent 1.",
          players: 1),
      QuestionData(
          text:
              "📚 {player1}, recommande une série. Ceux qui l'ont abandonnée boivent 1.",
          players: 1),
      QuestionData(
          text:
              "🧦 {player1}, le joueur avec les chaussettes les plus visibles boit 1.",
          players: 1),
      QuestionData(
          text:
              "🎨 {player1}, décris la soirée en une couleur. La table vote, perdant boit 1.",
          players: 1),
      QuestionData(
          text:
              "🫶 {player1}, choisis quelqu'un qui mérite une pause. Il saute sa prochaine gorgée.",
          players: 1),
      QuestionData(
          text:
              "🍵 {player1}, raconte ton rituel de lendemain de soirée ou bois 1.",
          players: 1),
      QuestionData(
          text:
              "🎲 {player1}, dé chill bonus : 1-3 tu bois 1, 4-6 tu donnes 1.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text:
              "💬 {player1}, donne une question légère à {player2}. Réponse ou 1 gorgée.",
          players: 2),
    ],
    'hot': [
      QuestionData(
          text:
              "🔥 {player1}, donne ton plus gros red flag en flirt ou bois 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "💋 {player1}, raconte ton pire message de drague ou bois 4 gorgées.",
          players: 1),
      QuestionData(
          text: "😏 {player1}, donne une note de flirt à {player2} ou bois 3.",
          players: 2),
      QuestionData(
          text:
              "🕯️ {player1} et {player2}, regard intense 15 secondes. Le premier qui rit boit 3.",
          players: 2),
      QuestionData(
          text:
              "📱 {player1}, lis le dernier message un peu ambigu que tu as reçu ou bois 4.",
          players: 1),
      QuestionData(
          text: "🍑 {player1}, cite ton type physique en soirée ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "🫦 {player1}, avoue une phrase de drague qui marche sur toi ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "💌 {player1}, qui ici aurait le plus de chance de te séduire en 5 minutes ? Réponds ou bois 4.",
          players: 1),
      QuestionData(
          text: "🔥 {player1}, raconte ton date le plus gênant ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "💬 {player1}, {player2} te pose une question flirt. Réponse ou 3 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🍷 {player1}, dis si tu préfères charme, humour ou audace. Ceux qui ne sont pas d'accord boivent 1.",
          players: 1),
      QuestionData(
          text:
              "👀 {player1}, qui ici a le regard le plus dangereux ? Cette personne boit 2.",
          players: 1),
      QuestionData(
          text: "🧨 {player1}, avoue ton pire faux pas en date ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "💄 {player1}, choisis le joueur qui aurait le meilleur profil de dating app. Il distribue 3.",
          players: 1),
      QuestionData(
          text:
              "🎭 {player1}, fais une imitation de flirt catastrophique ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "🥂 {player1} et {player2}, inventez un toast beaucoup trop charmeur ou buvez chacun 2.",
          players: 2),
      QuestionData(
          text:
              "🔒 {player1}, réponds : jaloux ou pas jaloux ? Si la table ne te croit pas, bois 3.",
          players: 1),
      QuestionData(
          text: "📸 {player1}, décris ta photo de profil idéale ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🃏 {player1}, donne une vérité hot mais pas physique. Refus = 4 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🎲 {player1}, lance le dé hot. Le score devient les gorgées à distribuer à une personne qui te plaît.",
          players: 1,
          type: QuestionType.dice),
      QuestionData(
          text:
              "🏁 Dernier regard : {player1}, choisis quelqu'un. Vous buvez chacun 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🔥 {player1}, quelle est la qualité la plus attirante chez {player2} ? Réponse ou 3 gorgées.",
          players: 2),
      QuestionData(
          text:
              "💌 {player1}, avoue le dernier compliment qui t'a vraiment touché ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🫣 {player1}, quelle situation de flirt te rend ridicule ? Réponse ou 3.",
          players: 1),
      QuestionData(
          text:
              "🔥 {player1}, qui ici a le plus de charisme quand il parle ? Il distribue 3.",
          players: 1),
      QuestionData(
          text:
              "📱 {player1}, ton dernier emoji envoyé est ton mood flirt. Explique ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "🍷 {player1}, raconte une phrase de date qui t'a refroidi ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "😈 {player1}, donne un green flag et un red flag de {player2}. Refus = 4.",
          players: 2),
      QuestionData(
          text:
              "🎭 {player1}, joue une scène de rencontre catastrophique. Si la table rit, distribue 3.",
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
              "🏁 {player1}, dernière tension : donne ton avis le plus honnête sur le charme de la table ou bois 5.",
          players: 1),
    ],
    'express': [
      QuestionData(
          text:
              "⚡ {player1}, cite 3 marques de voiture en 5 secondes ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🏃 {player1}, touche un mur et reviens. Le dernier assis boit 2.",
          players: 1),
      QuestionData(
          text: "📢 Le dernier qui crie TCHIN boit 3 gorgées.", players: 1),
      QuestionData(
          text: "🍺 {player1}, bois 2 gorgées le plus vite possible.",
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
              "🚀 {player1}, fais rire {player2} en 10 secondes. Le perdant boit 2.",
          players: 2),
      QuestionData(
          text:
              "🍺 Service rapide : le premier qui dit le prénom de {player1} distribue 3 gorgées.",
          players: 1),
      QuestionData(
          text: "🎯 {player1}, donne 5 prénoms en 8 secondes ou bois 3.",
          players: 1),
      QuestionData(
          text: "🧠 {player1}, cite 3 applis sans réfléchir ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🎲 {player1}, lance le dé express. Score pair = tu bois 2, impair = tu distribues 2.",
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
              "🍻 {player1}, choisis vite : boire 3 ou faire boire {player2} 2.",
          players: 2),
      QuestionData(
          text:
              "🗣️ {player1}, dis une phrase sans la lettre A. Erreur = 2 gorgées.",
          players: 1),
      QuestionData(
          text: "🔁 {player1}, inverse le sens du jeu et bois 1.", players: 1),
      QuestionData(text: "🔥 Dernier à applaudir boit 2 gorgées.", players: 1),
      QuestionData(
          text:
              "🏁 Sprint final : tout le monde boit 1, {player1} distribue 2.",
          players: 1),
      QuestionData(
          text: "⚡ {player1}, cite 3 réseaux sociaux en 4 secondes ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🧃 {player1}, nomme 3 boissons sans alcool en 5 secondes ou bois 2.",
          players: 1),
      QuestionData(
          text: "🎵 Le dernier qui fredonne quelque chose boit 2 gorgées.",
          players: 1),
      QuestionData(
          text: "📣 {player1}, dis santé dans 3 langues ou bois 3.",
          players: 1),
      QuestionData(
          text:
              "🧠 {player1}, cite 4 marques de vêtements en 7 secondes ou bois 2.",
          players: 1),
      QuestionData(text: "🏃 Dernier debout boit 2 gorgées.", players: 1),
      QuestionData(
          text: "🎯 {player1}, pointe un objet noir en 2 secondes ou bois 2.",
          players: 1),
      QuestionData(
          text:
              "🍺 {player1}, choisis rapidement gauche ou droite. Le joueur de ce côté boit 2.",
          players: 1),
      QuestionData(
          text:
              "🔁 Tout le monde change de place mentalement : le prochain qui oublie le sens boit 2.",
          players: 1),
      QuestionData(
          text:
              "🏁 Flash : {player1}, donne 1 gorgée à deux personnes en moins de 5 secondes.",
          players: 1),
    ],
    'borderline': [
      QuestionData(
          text:
              "💀 {player1}, avoue le plus gros mensonge que tu as déjà dit en couple ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "🔥 {player1}, qui ici serait ton choix le plus honteux pour un plan secret ? Réponds ou shot.",
          players: 1),
      QuestionData(
          text:
              "🧨 {player1}, raconte une anecdote de drogue ou de soirée illégale. Refus = 5 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🍆 {player1}, as-tu déjà envoyé un nude regrettable ? Raconte le contexte ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "💊 {player1}, quelle est la substance la plus risquée que tu as déjà prise ou failli prendre ? Réponse ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "🥀 {player1}, as-tu déjà trompé quelqu'un ou aidé quelqu'un à tromper ? Réponse ou 6 gorgées.",
          players: 1),
      QuestionData(
          text:
              "☠️ {player1}, qui ici aurait le plus de chances de finir en garde à vue en soirée ? Il boit 4.",
          players: 1),
      QuestionData(
          text:
              "👻 {player1}, as-tu déjà ghosté quelqu'un après avoir couché avec ? Raconte ou shot.",
          players: 1),
      QuestionData(
          text:
              "🖤 {player1}, donne ton fantasme le plus tabou en version courte ou bois 6 gorgées.",
          players: 1),
      QuestionData(
          text:
              "📱 {player1}, montre le nom de ton dernier contact bloqué ou bois 5 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🤥 {player1}, raconte une fois où tu as manipulé quelqu'un ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "💸 {player1}, as-tu déjà menti sur l'argent, une dette ou un paiement ? Réponse ou 4 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🍑 {player1}, body count : donne le chiffre ou bois 6 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🧾 {player1}, quelle est la pire chose que tu as faite bourré ? Refus = cul sec.",
          players: 1),
      QuestionData(
          text:
              "🧠 {player1}, qui ici a le plus gros ego sexuel selon toi ? Cette personne boit 3.",
          players: 1),
      QuestionData(
          text:
              "👀 {player1}, as-tu déjà eu envie de quelqu'un déjà pris ? Réponse ou 5 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🚫 {player1}, cite une limite morale que tu as déjà franchie ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "💬 {player1}, lis le dernier message très embarrassant que tu as envoyé ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "🕳️ {player1}, quelle recherche internet te ferait le plus honte ici ? Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "🧪 {player1}, as-tu déjà mélangé alcool et drogue ? Raconte la conséquence ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "💔 {player1}, as-tu déjà couché avec quelqu'un par vengeance, jalousie ou ego ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "😈 {player1}, choisis entre révéler ton pire crush secret ou boire cul sec.",
          players: 1),
      QuestionData(
          text:
              "🧨 {player1}, {player2} te pose une question sexuelle directe. Réponds ou bois 5.",
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
              "🧟 {player1}, as-tu déjà menti sur ton état pour continuer une soirée ? Réponse ou 4.",
          players: 1),
      QuestionData(
          text:
              "📸 {player1}, as-tu déjà gardé une photo compromettante ? Réponse ou 5 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🧯 {player1}, quelle rumeur sur toi serait la plus crédible ? Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "💣 {player1}, nomme une personne ici que tu ne laisserais jamais sortir avec ton ex. Elle boit 3.",
          players: 1),
      QuestionData(
          text:
              "🥃 {player1}, cul sec si tu as déjà menti sur ton nombre de conquêtes. Sinon distribue 4.",
          players: 1),
      QuestionData(
          text:
              "💊 {player1}, raconte une fois où quelqu'un a trop abusé en soirée. Refus = 4 gorgées.",
          players: 1),
      QuestionData(
          text:
              "👁️ {player1}, qui ici a le plus de secrets sexuels selon toi ? Il ou elle boit 4.",
          players: 1),
      QuestionData(
          text:
              "🧛 {player1}, as-tu déjà profité d'une situation pour obtenir quelque chose ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "📵 {player1}, montre seulement le prénom de ton dernier message hot ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "☠️ {player1}, quelle est la pire trahison que tu as faite ou subie ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "🔥 {player1}, {player2} doit deviner ton plus gros vice. S'il a tort, il boit 4, sinon tu bois 4.",
          players: 2),
      QuestionData(
          text:
              "🧾 Addition noire : {player1}, raconte une vérité que tu n'assumes pas ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "🍺 {player1}, bois 1 gorgée pour chaque ex que tu éviterais dans la rue.",
          players: 1),
      QuestionData(
          text:
              "💥 {player1}, as-tu déjà fait quelque chose d'illégal pour impressionner quelqu'un ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "🧊 {player1}, la table choisit une question taboue. Tu réponds ou tu bois 6.",
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
              "⚡ {player1}, {player2} et {player3}, chacun vote pour le plus borderline. Il boit cul sec.",
          players: 3),
      QuestionData(
          text:
              "🧨 {player1}, raconte ta pire décision prise après 2h du matin ou bois 6.",
          players: 1),
      QuestionData(
          text:
              "💀 {player1}, si la table lisait tes DM, quel serait le thème du scandale ? Réponse ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "🏁 Sentence finale : {player1}, réponds à une question taboue choisie par la table ou bois shot + 3 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🕷️ {player1}, as-tu déjà flirté avec quelqu'un uniquement par intérêt ? Réponse ou 6 gorgées.",
          players: 1),
      QuestionData(
          text:
              "💀 {player1}, quelle personne de ton passé ne doit surtout pas entendre parler de cette soirée ? Réponse ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "💊 {player1}, as-tu déjà menti sur une consommation pour éviter un jugement ? Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "🔞 {player1}, as-tu déjà regretté immédiatement après avoir couché avec quelqu'un ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "📱 {player1}, quel type de message supprimé te ferait le plus peur ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "🧨 {player1}, avoue une fois où tu as joué avec les sentiments de quelqu'un ou bois cul sec.",
          players: 1),
      QuestionData(
          text:
              "🍆 {player1}, as-tu déjà menti sur tes performances sexuelles ? Réponse ou 5 gorgées.",
          players: 1),
      QuestionData(
          text:
              "☠️ {player1}, qui ici aurait le casier judiciaire fictif le plus long ? Il boit 4.",
          players: 1),
      QuestionData(
          text:
              "🫥 {player1}, raconte une honte que tu n'as jamais assumée à tes amis ou bois shot.",
          players: 1),
      QuestionData(
          text:
              "💉 {player1}, connais-tu quelqu'un qui a déjà dérapé à cause d'une drogue ? Raconte sans nom ou bois 5.",
          players: 1),
      QuestionData(
          text:
              "💔 {player1}, as-tu déjà gardé quelqu'un sous le coude ? Réponse ou 6 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🔥 {player1}, quelle est ta pensée la plus toxique en relation ? Réponse ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "🧾 {player1}, la table choisit entre sexe, drogue ou argent. Tu réponds à une question sur le thème ou shot.",
          players: 1),
      QuestionData(
          text:
              "😈 {player1}, {player2} choisit un secret à moitié avoué. Tu complètes ou 5 gorgées.",
          players: 2),
      QuestionData(
          text:
              "🖤 {player1}, qui ici serait le plus capable de mentir sans trembler ? Il boit 4.",
          players: 1),
      QuestionData(
          text:
              "📸 {player1}, as-tu déjà demandé ou reçu une photo très privée ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "🥃 {player1}, cul sec si tu as déjà menti pour éviter de revoir quelqu'un.",
          players: 1),
      QuestionData(
          text:
              "🚨 {player1}, raconte une soirée où quelqu'un aurait dû rentrer plus tôt ou bois 4.",
          players: 1),
      QuestionData(
          text:
              "💣 {player1}, nomme la personne ici qui ferait le pire ex. Elle boit 3 et peut répondre.",
          players: 1),
      QuestionData(
          text:
              "🔒 {player1}, as-tu déjà caché une relation ou un flirt ? Réponse ou shot.",
          players: 1),
      QuestionData(
          text:
              "🧪 {player1}, quelle limite tu ne franchirais plus jamais en soirée ? Réponse ou 5.",
          players: 1),
      QuestionData(
          text:
              "👁️ {player1}, qui ici a la vie privée la plus dangereuse à fouiller ? Il boit 4.",
          players: 1),
      QuestionData(
          text: "🕳️ {player1}, avoue une jalousie honteuse ou bois 6 gorgées.",
          players: 1),
      QuestionData(
          text:
              "💬 {player1}, donne une vérité que tu n'écrirais jamais par message ou cul sec.",
          players: 1),
      QuestionData(
          text:
              "⚡ {player1}, {player2} et {player3}, votez pour le plus gros danger en after. Il boit 5.",
          players: 3),
      QuestionData(
          text:
              "🧨 {player1}, as-tu déjà ruiné une relation pour une attirance ? Réponse ou 6.",
          players: 1),
      QuestionData(
          text:
              "💀 {player1}, la table choisit une vérité interdite. Si tu esquives, shot + 2 gorgées.",
          players: 1),
      QuestionData(
          text:
              "🏁 Pacte noir : {player1}, choisis quelqu'un qui doit répondre à une question taboue ou boire cul sec.",
          players: 1),
      QuestionData(
          text: "🍷 Le verre du milieu... La tension monte.",
          players: 1,
          type: QuestionType.centralGlass),
    ],
  };
}
