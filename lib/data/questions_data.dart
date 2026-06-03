
import '../models/question_model.dart';

// Wrapper class to match the JS structure structure
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
      QuestionData(text: "🎉 {player1}, tout le monde boit sauf toi !", players: 1),
      QuestionData(text: "👑 {player1} devient le roi/la reine. Tout le monde doit t'obéir pendant 2 tours !", players: 1),
      QuestionData(text: "🎤 {player1}, chante une chanson ou bois 2 gorgées.", players: 1),
      QuestionData(text: "💃 {player1}, fais une danse ridicule ou bois 3 gorgées.", players: 1),
      
      QuestionData(text: "🥃 {player1}, tout le monde boit sauf toi.", players: 1),
      QuestionData(text: "🍸 {player1}, choisis une personne qui boit 4 gorgées.", players: 1),
      QuestionData(text: "🥂 {player1}, bois 2 gorgées puis distribue-en 2.", players: 1),
      QuestionData(text: "👀 {player1}, désigne la personne la plus susceptible de finir ivre ce soir. Elle boit 3 gorgées.", players: 1),
      QuestionData(text: "🍻 Tout le monde boit 2 gorgées.", players: 1),
      QuestionData(text: "🎯 {player1}, choisis : boire 5 gorgées ou faire boire 3 personnes.", players: 1),
      QuestionData(text: "🧠 {player1}, avoue une mauvaise habitude ou bois 3 gorgées.", players: 1),
      QuestionData(text: "👑 {player1}, choisis quelqu’un pour boire cul sec.", players: 1),
      QuestionData(text: "📊 {player1}, bois autant de gorgées que de verres déjà bus ce soir.", players: 1),
      QuestionData(text: "😏 {player1}, dis qui, selon toi, est le plus sûr de lui ici. Il/elle boit 2 gorgées.", players: 1),
      QuestionData(text: "🚫 {player1}, refuse la prochaine action et bois 2 gorgées à la place.", players: 1),
      QuestionData(text: "🕶️ {player1}, si tu as déjà menti ce soir, bois 3 gorgées. Sinon, fais boire quelqu’un.", players: 1),
      QuestionData(text: "🃏 {player1}, distribue 6 gorgées comme tu veux.", players: 1),
      QuestionData(text: "🚬 {player1}, si tu as déjà fait une pause ce soir, bois 2 gorgées. Sinon, fais boire quelqu’un.", players: 1),
      QuestionData(text: "👁️ {player1}, désigne la personne qui se contrôle le moins ce soir. Elle boit 2 gorgées.", players: 1),
      QuestionData(text: "🔥 {player1}, choisis deux joueurs : ils boivent cul sec ensemble.", players: 1),
      QuestionData(text: "🔗 {player1}, choisis quelqu’un : vous buvez ensemble à chaque tour pendant 2 tours.", players: 1),
      QuestionData(text: "⏳ {player1}, bois 1 gorgée pour chaque joueur autour de la table.", players: 1),
      QuestionData(text: "⛓️ {player1}, choisis quelqu’un : tant que l’un boit, l’autre boit aussi (2 tours).", players: 1),
      QuestionData(text: "🚀 {player1}, invente une règle qui s'applique à tout le monde jusqu'à ton prochain tour.", players: 1),
      QuestionData(text: "🤔 {player1}, réponds à une question personnelle ou bois 2 gorgées.", players: 1),
      QuestionData(text: "🍑 {player1}, avec qui tu pourrais avoir un rapport Anal dans la soirée, sinon bois 5 gorgées.", players: 1),
      QuestionData(text: "🍷 Tous le monde boit.", players: 1),
      QuestionData(text: "👨‍🦰 Tous les roux doivent boire 5 gorgées", players: 1),
      QuestionData(text: "👩 Toutes les femmes doivent cul sec leur verre", players: 1),
      QuestionData(text: "🍻 {player1}, bois 3 gorgées si {player2} t'a déjà battu à un jeu vidéo.", players: 2),
      QuestionData(text: "🔄 {player1} et {player2} doivent échanger de verre !", players: 2),
      QuestionData(text: "🤔 {player1}, réponds à cette question : Quel est le pire date de {player2} ?", players: 2),
      QuestionData(text: "🤗 {player1} et {player2} doivent se serrer dans les bras pendant 30 secondes.", players: 2),
      QuestionData(text: "😜 {player1}, imite {player2} pendant 1 minute.", players: 2),
      QuestionData(text: "💝 {player1}, fais un compliment à {player2}.", players: 2),
      QuestionData(text: "🎁 {player1}, offre une gorgée de ta boisson à {player2}.", players: 2),
      QuestionData(text: "🎤 {player1} et {player2}, chantez un duo ou buvez chacun 2 gorgées.", players: 2),
      QuestionData(text: "💃 {player1} et {player2}, dansez ensemble ou buvez chacun 2 gorgées.", players: 2),
      QuestionData(text: "✂️ {player1} et {player2}, jouez à pierre-feuille-ciseaux. Le perdant boit 2 gorgées.", players: 2),
      QuestionData(text: "🎲 {player1}, {player2} et {player3}, lancez les dés : 1-2 = bois 1, 3-4 = bois 2, 5-6 = bois 3 gorgées.", players: 3),
      QuestionData(text: "🚀 {player1}, invente une règle avec {player2} et {player3} qui s'applique à tout le monde jusqu'à ton prochain tour.", players: 3),
      QuestionData(text: "🎯 {player1}, {player2} et {player3}, faites un concours de danse. Le perdant boit 2 gorgées.", players: 3),
      QuestionData(text: "🤗 {player1}, {player2} et {player3}, créez une pyramide humaine pendant 10 secondes.", players: 3),
      QuestionData(text: "🍻 {player1}, {player2} et {player3}, trinquez ensemble et buvez 2 gorgées.", players: 3),
      QuestionData(text: "🎉 {player1}, {player2} et {player3}, criez le plus fort possible !", players: 3),
      QuestionData(text: "💃 {player1}, {player2} et {player3}, faites une chorégraphie synchronisée.", players: 3),
      QuestionData(text: "🎤 {player1}, {player2} et {player3}, chantez une chanson ensemble.", players: 3),
      // Morpion
      QuestionData(
        text: "Morpion ! ❌⭕\n{player1} défie quelqu'un en 1v1.", 
        players: 1, 
        type: QuestionType.ticTacToe
      ),
      QuestionData(text: "🕺 {player1}, fais le moonwalk à travers la pièce.", players: 1),
      QuestionData(text: "🧛 {player1}, bois 5 gorgées ton verre en le tenant uniquement avec tes dents.", players: 1),
      QuestionData(text: "💣 {player1}, choisis un mot interdit. Quiconque le dit avant ton prochain tour boit 3 gorgée.", players: 1),
      QuestionData(text: "🎩 {player1}, invente ton titre de noblesse (ex : Duc/Duchesse des chips). Tout le monde doit t’appeler comme ça. Chaque erreur est égale à 3 gorgée", players: 1),
      QuestionData(text: "😬 {player1}, Casse  un glaçon avec ton front.", players: 1),
      QuestionData(text: "🦵 {player1}, bois une gorgée sans utiliser tes mains.", players: 1),
      QuestionData(text: "💥 {player1}, choisis un joueur qui doit boire 2 gorgées immédiatement.", players: 1),
      QuestionData(
        text: "🎡 {player1}, tourne la Roue de la Fortune !", 
        players: 1, 
        type: QuestionType.wheel
      ),
      /*
      QuestionData(
        text: "🎰 {player1}, tente ta chance au Jackpot !", 
        players: 1, 
        type: QuestionType.slotMachine
      ),
      */
      
    ],
    
    'duo': [
      QuestionData(text: "👥 {player1} et {player2}, buvez ensemble 3 gorgées en vous regardant dans les yeux.", players: 2),
      QuestionData(text: "💑 {player1} et {player2}, simulez une scène de film romantique ou buvez chacun 2 gorgées.", players: 2),
      QuestionData(text: "🤝 {player1} et {player2}, tenez-vous la main jusqu'au prochain tour de {player1}.", players: 2),
      QuestionData(text: "🎤 {player1} et {player2}, chantez un duo ou buvez chacun 3 gorgées.", players: 2),
      QuestionData(text: "💃 {player1} et {player2}, dansez ensemble ou buvez chacun 2 gorgées.", players: 2),
      QuestionData(text: "👥 {player1} et {player2}, devenez partenaires pour le prochain tour. Si l'un boit, l'autre boit aussi.", players: 2),
      QuestionData(text: "😜 {player1} et {player2}, faites une imitation célèbre ou buvez chacun 2 gorgées.", players: 2),
      QuestionData(text: "🎭 {player1} et {player2}, improvisez une scène de théâtre ou buvez chacun 3 gorgées.", players: 2),
      QuestionData(text: "🍻 {player1} et {player2}, buvez en même temps jusqu'à ce que l'un des deux s'arrête.", players: 2),
      QuestionData(text: "👑 {player1} et {player2}, vous êtes roi et reine. Donnez un ordre à tout le monde.", players: 2),
      QuestionData(text: "💝 {player1} et {player2}, faites-vous un câlin pendant 20 secondes.", players: 2),
      QuestionData(text: "👀 {player1} et {player2}, jouez à un jeu de regard sans rire.", players: 2),
      QuestionData(text: "🤝 {player1} et {player2}, portez-vous mutuellement pendant 30 secondes.", players: 2),
      QuestionData(text: "🎤 {player1} et {player2}, inventez une chanson ensemble.", players: 2),
      QuestionData(text: "💃 {player1} et {player2}, dansez comme si vous étiez en boîte de nuit.", players: 2)
    ],
    'bar': [
      QuestionData(text: "🍸 {player1}, fais le tour du bar et ramène 3 numéros de téléphone !", players: 1),
      QuestionData(text: "🎤 {player1}, chante une chanson karaoké ou bois 4 gorgées.", players: 1),
      QuestionData(text: "💃 {player1}, danse sur la table pendant 30 secondes.", players: 1),
      QuestionData(text: "🎩 {player1}, fais un tour de magie ou bois 3 gorgées.", players: 1),
      QuestionData(text: "🥃 {player1}, bois un shot cul sec !", players: 1),
      QuestionData(text: "🎲 {player1}, lance un dé : 1-3 = bois 1 shot, 4-6 = bois 2 shots.", players: 1),
      QuestionData(text: "🎉 {player1}, crie 'Tchin Tchin' le plus fort possible !", players: 1),
      QuestionData(text: "💃 {player1}, fais la danse de la limbo sous une canne.", players: 1),
      QuestionData(text: "🎭 {player1}, imite une célébrité célèbre.", players: 1),
      QuestionData(text: "🍸 {player1}, invente un nouveau cocktail et bois-le.", players: 1),
      QuestionData(text: "👥 {player1} et {player2}, buvez un shot en vous regardant dans les yeux.", players: 2),
      QuestionData(text: "✂️ {player1} et {player2}, jouez à pierre-feuille-ciseaux. Le perdant paie le prochain verre.", players: 2),
      QuestionData(text: "💋 {player1} et {player2}, simulez un baiser de cinéma ou buvez 2 gorgées.", players: 2),
      QuestionData(text: "🤝 {player1} et {player2}, portez-vous mutuellement jusqu'au comptoir.", players: 2),
      QuestionData(text: "🎤 {player1} et {player2}, chantez 'I Will Always Love You' en duo.", players: 2),
      QuestionData(text: "💃 {player1} et {player2}, dansez le slow ensemble.", players: 2),
      QuestionData(text: "🍻 {player1} et {player2}, trinquez et buvez en criant 'Santé !'", players: 2),
      QuestionData(text: "⚡ {player1} et {player2}, faites un concours de rapidité pour boire votre verre.", players: 2),
      QuestionData(text: "💝 {player1} et {player2}, faites-vous un bisou sur la joue.", players: 2),
      QuestionData(text: "👥 {player1} et {player2}, marchez en vous tenant par le bras comme un couple.", players: 2),
      QuestionData(text: "🎉 {player1}, {player2} et {player3}, criez 'Tchin Tchin' le plus fort possible !", players: 3),
      QuestionData(text: "💃 {player1}, {player2} et {player3}, faites une chorégraphie synchronisée.", players: 3),
      QuestionData(text: "⚡ {player1}, {player2} et {player3}, jouez à un concours de rapidité. Le plus lent paie un shot.", players: 3),
      QuestionData(text: "🤝 {player1}, {player2} et {player3}, formez une pyramide humaine devant le bar.", players: 3),
      QuestionData(text: "🥃 {player1}, {player2} et {player3}, faites un concours de shot. Le dernier à finir paie la tournée.", players: 3),
      QuestionData(text: "🎤 {player1}, {player2} et {player3}, chantez une chanson à trois voix.", players: 3),
      QuestionData(text: "💃 {player1}, {player2} et {player3}, faites la conga dans tout le bar.", players: 3),
      QuestionData(text: "🎉 {player1}, {player2} et {player3}, faites un toast ensemble en criant.", players: 3)
    ],
    'chill': [
      QuestionData(text: "😌 {player1}, raconte ton meilleur souvenir de vacances. Toute personne qui y est déjà allée boit 1.", players: 1),
      QuestionData(text: "🍔 {player1}, quel est ton plat préféré ? Si quelqu'un d'autre l'adore aussi, vous trinquez.", players: 1),
      QuestionData(text: "🎶 {player1}, cite une chanson honteuse que tu adores. Ceux qui la connaissent boivent 1.", players: 1),
      QuestionData(text: "🛋️ Tout le monde s'installe confortablement. Le dernier assis boit 2.", players: 1),
      QuestionData(text: "🤝 {player1} donne un compliment sincère à {player2}.", players: 2),
      QuestionData(text: "📸 {player1} et {player2}, prenez un selfie ensemble !", players: 2),
      QuestionData(text: "🎭 {player1}, imite un animal. {player2} doit deviner lequel. Si il trouve, il donne 2.", players: 2)
    ],
    'hot': [
      QuestionData(text: "🔥 {player1}, quel est ton plus grand 'turn-on' ? Réponds ou bois 3.", players: 1),
      QuestionData(text: "💋 {player1}, fais un bisou sur la joue de {player2}.", players: 2),
      QuestionData(text: "🔥 {player1}, qui est la personne la plus sexy ici ? Réponds ou bois 4.", players: 1),
      QuestionData(text: "🫦 {player1}, chuchote quelque chose de coquin à {player2}.", players: 2),
      QuestionData(text: "🧤 {player1}, enlève un vêtement ou bois 5 gorgées.", players: 1),
      QuestionData(text: "🍑 {player1}, touche les fesses de {player2} ou bois 4.", players: 2),
      QuestionData(text: "🍆 {player1}, avec quoi dans cette pièce ressembles-tu le plus sexuellement ? Bois 2 si tu refuses de répondre.", players: 1),
      QuestionData(text: "🖤 Ceux qui portent des sous-vêtements noirs boivent 2.", players: 1),
      QuestionData(text: "🍑 {player1}, est ce que tu pourrais coucher avec {player2} ou si tu veux pas répondre bois 4.", players: 2)

    ],
    'express': [
      QuestionData(text: "⚡ {player1}, vite ! Cite 3 marques de voiture en 5 secondes !", players: 1),
      QuestionData(text: "🏃 {player1}, touche un mur et reviens ! Le dernier qui s'assoit boit 2.", players: 1),
      QuestionData(text: "📢 Le dernier qui crie 'TCHIN' boit 3.", players: 1),
      QuestionData(text: "🍺 {player1}, bois 2 gorgées le plus vite possible !", players: 1),
      QuestionData(text: "🤚 Le dernier qui lève la main boit 2.", players: 1),
      QuestionData(text: "🧱 {player1}, touche un objet rouge en moins de 3 secondes ou bois 2.", players: 1)
    ],
    'borderline': [
      QuestionData(text: "💀 {player1}, quel est le pire secret que tu caches à {player2} ?", players: 2),
      QuestionData(text: "🕵️ {player1}, montre ta dernière recherche Google ou cul sec.", players: 1),
      QuestionData(text: "🐍 {player1}, qui est la personne la moins fiable ici selon toi ?", players: 1),
      QuestionData(text: "💣 {player1}, raconte ton pire 'date' amoureux ou bois 5.", players: 1),
      QuestionData(text: "💔 {player1}, si tu devais supprimer quelqu'un de ton répertoire ici, qui serait-ce ?", players: 1),
      QuestionData(text: "🥀 {player1}, quelle est la pire chose que tu aies faite par vengeance ?", players: 1),
      QuestionData(text: "🤼‍♂️ {player1} et {player2}, faites un combat de pouces. Le perdant boit cul sec.", players: 2),
      QuestionData(text: "👈 Toute les personnes qui sont gauché boive X2.", players: 1),
      QuestionData(text: "😈 {player1}, tu es le roi/la reine du cul sec. Ordonne à quelqu'un de vider son verre.", players: 1),
      QuestionData(text: "😈 🔥 {player1}, {player2} et {player3}, le dernier à toucher le sol avec une main autre que la sienne boit 3.", players: 3),
      QuestionData(text: "🎁 {player1}, {player2} et {player3}, l'un de vous reçoit un « cadeau empoisonné » : il boit son verre + celui du voisin de gauche. Désignez la victime !", players: 3),
      QuestionData(text: "🤢 {player1}, bois 4 gorgées si t'as déjà vomi en soirée. Sinon, 2 pour ta prétention.", players: 1),
      QuestionData(text: "🔄 Règle du miroir : {player1} prend une gorgée. Son voisin de droite doit la prendre également. Jusqu'au prochait tour de {player1}.", players: 1),
      QuestionData(text: "💥 {player1}, bois 5 gorgées d'affilée !", players: 1),
      QuestionData(text: "🚫 {player1}, tu ne peux plus parler jusqu'à ton prochain tour. À chaque infraction, bois 2 gorgées.", players: 1),
      QuestionData(text: "⏰ {player1}, bois toutes les 30 secondes pendant 5 minutes.", players: 1),
      QuestionData(text: "📱 {player1}, poste une photo embarrassante sur les réseaux sociaux ou bois 10 gorgées.", players: 1),
      QuestionData(text: "❄️ {player1}, tu dois garder un glaçon dans ta bouche jusqu'à ce qu'il fonde.", players: 1),
      QuestionData(text: "💀 {player1}, bois jusqu'à ce que quelqu'un te dise d'arrêter.", players: 1),
      QuestionData(text: "🎯 {player1}, si tu rates ce lancer de dé, bois le double de gorgées indiquées.", players: 1),
      QuestionData(text: "💥 {player1}, bois ton verre cul sec !", players: 1),
      QuestionData(text: "💀 {player1}, bois 3 gorgées les yeux fermés.", players: 1),
      QuestionData(text: "🚫 {player1}, tu ne peux pas utiliser ta main dominante jusqu'au prochain tour.", players: 1),
      QuestionData(text: "🤢 {player1}, mélange 3 boissons différentes avec {player2} et bois le cocktail !", players: 2),
      QuestionData(text: "🔄 {player1}, échange ton verre avec celui de {player2}.", players: 2),
      QuestionData(text: "⚔️ {player1}, défie {player2} dans un duel de boisson. Le perdant boit 5 gorgées supplémentaires.", players: 2),
      QuestionData(text: "✂️ {player1} et {player2}, jouez à pierre-feuille-ciseaux. Le perdant boit 4 gorgées.", players: 2),
      QuestionData(text: "💥 {player1} et {player2}, buvez 3 gorgées en même temps sans vous arrêter.", players: 2),
      QuestionData(text: "💀 {player1}, bois jusqu'à ce que {player2} te dise d'arrêter.", players: 2),
      QuestionData(text: "🤢 {player1} et {player2}, échangez vos verres et buvez d'un trait.", players: 2),
      QuestionData(text: "⚔️ {player1} et {player2}, faites un concours de regard. Le premier qui rit boit 4 gorgées.", players: 2),
      QuestionData(text: "💥 {player1} et {player2}, buvez en vous regardant dans les yeux sans rire.", players: 2),
      QuestionData(text: "🎯 {player1} et {player2}, le dernier à finir son verre boit 3 gorgées supplémentaires.", players: 2),
      QuestionData(text: "💀 {player1}, {player2} et {player3}, le dernier à finir son verre boit 5 gorgées supplémentaires.", players: 3),
      QuestionData(text: "🎯 {player1}, {player2} et {player3}, faites un concours de rapidité. Le plus lent boit 3 gorgées.", players: 3),
      QuestionData(text: "🤢 {player1}, {player2} et {player3}, mélangez vos boissons et buvez un shot chacun.", players: 3),
      QuestionData(text: "💥 {player1}, {player2} et {player3}, buvez en cercle jusqu'à ce que quelqu'un abandonne.", players: 3),
      QuestionData(text: "⚔️ {player1}, {player2} et {player3}, faites un concours de regard. Le premier qui rit boit 3 gorgées.", players: 3),
      QuestionData(text: "🎲 {player1}, {player2} et {player3}, jouez à un jeu de rapidité. Le perdant boit 4 gorgées.", players: 3),
      QuestionData(text: "💀 {player1}, {player2} et {player3}, buvez en même temps. Le dernier à s'arrêter gagne.", players: 3),
      QuestionData(text: "💥 {player1}, {player2} et {player3}, faites une chaîne de boisson sans vous arrêter.", players: 3),
      
      // New Borderline Questions
      QuestionData(text: "🤢 {player1}, cite le nom de la personne ici avec qui tu aurais le plus de mal à coucher.", players: 1),
      QuestionData(text: "💔 {player1}, qui dans cette pièce finira célibataire selon toi ?", players: 1),
      QuestionData(text: "🤳 {player1}, fais défiler tes photos et laisse {player2} en choisir une à montrer à tout le monde.", players: 2),
      QuestionData(text: "☠️ {player1}, si tu devais tuer quelqu'un ici pour sauver ta peau, qui choisirais-tu ?", players: 1),
      QuestionData(text: "🥵 {player1}, fais un massage sensuel des épaules à {player2} pendant 30 secondes ou bois 4 gorgées.", players: 2),
      QuestionData(text: "🤥 {player1}, as-tu déjà trompé quelqu'un ? Raconte ou finis ton verre.", players: 1),
      QuestionData(text: "👻 {player1}, as-tu déjà 'ghosté' quelqu'un ici ? Si oui, bois 3 gorgées.", players: 1),
      QuestionData(text: "👂 {player1}, laisse {player2} te chuchoter un truc dégueulasse à l'oreille sans rire.", players: 2),
      QuestionData(text: "🤬 {player1}, insulte {player2} avec ton meilleur vocabulaire fleuri pendant 10 secondes.", players: 2),
      QuestionData(text: "🖕 {player1}, fais un doigt d'honneur à la personne que tu aimes le moins ici (ou bois 3 gorgées si tu es lâche).", players: 1),
      QuestionData(text: "🤷‍♂️ {player1}, qui ici a le pire style vestimentaire selon toi ?", players: 1),
      QuestionData(text: "🧠 {player1}, qui ici est le plus 'bête' ou 'lent' selon toi ?", players: 1),
      QuestionData(text: "💊 {player1}, as-tu déjà pris des drogues ? Si oui, raconte une anecdote ou bois 5 gorgées.", players: 1),
      QuestionData(text: "🍆 {player1}, envoie 'J'ai envie de toi' à ton dernier contact Messenger/WhatsApp (sans explication pendant 10 min) ou bois cul sec.", players: 1),
      QuestionData(text: "🤐 {player1}, tu n'as pas le droit de dire 'non' ou de refuser quoi que ce soit jusqu'au prochain tour.", players: 1),
      QuestionData(text: "👅 {player1}, lèche le cou de {player2} ou bois 4 gorgées.", players: 2),
      QuestionData(text: "🦶 {player1}, masse les pieds de {player2} (avec chaussettes) pendant 30 secondes.", players: 2),
      QuestionData(text: "🤰 {player1}, qui ici ferait le pire parent ?", players: 1),
      QuestionData(text: "🧟 {player1}, qui ici mourrait le premier dans un film d'horreur ?", players: 1),
      QuestionData(text: "🗣️ {player1}, dis un secret sur {player2} que personne d'autre ne sait.", players: 2),
      QuestionData(text: "🍺 {player1}, bois une gorgée dans le verre de chacun des autres joueurs.", players: 1),
      QuestionData(text: "🧊 {player1}, mets un glaçon dans ton pantalon/jupe jusqu'à ce qu'il fonde.", players: 1),
      QuestionData(text: "🧵 {player1}, échange un vêtement avec {player2}.", players: 2),
      QuestionData(text: "💩 {player1}, raconte ta pire honte en public.", players: 1),
      QuestionData(text: "🤤 {player1}, qui ici a les plus belles fesses ?", players: 1),
      QuestionData(text: "🦴 {player1}, nomme une personne ici avec qui tu as déjà eu des pensées impures.", players: 1),
      QuestionData(text: "☠️ TOUT LE MONDE : Le dernier qui touche le sol boit 5 gorgées !", players: 1),
      
      // Central Glass Logic (BorderLine only)
      QuestionData(
        text: "🍷 Le verre du milieu... La tension monte !", 
        players: 1, 
        type: QuestionType.centralGlass
      ),
      


    ]
  };
}
