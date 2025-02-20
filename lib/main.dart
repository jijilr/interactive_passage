import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Passage Feedback',
      home: PassageScreen(),
    );
  }
}

class PassageScreen extends StatefulWidget {
  @override
  _PassageScreenState createState() => _PassageScreenState();
}

class _PassageScreenState extends State<PassageScreen> {
  // The passage is split into sentences.
  final List<String> sentences = [
    "The biggest challenge [The Nutmeg's Curse by Ghosh] throws down is to the prevailing understanding of when the climate crisis started. ",
    "Most of us have accepted . . . that it started with the widespread use of coal at the beginning of the Industrial Age in the 18th century and worsened with the mass adoption of oil and natural gas in the 20th. ",
    "Ghosh takes this history at least three centuries back, to the start of European colonialism in the 15th century. ",
    "He [starts] the book with a 1621 massacre by Dutch invaders determined to impose a monopoly on nutmeg cultivation and trade in the Banda islands in today's Indonesia. ",
    // End of Paragraph 1
    "Not only do the Dutch systematically depopulate the islands through genocide, they also try their best to bring nutmeg cultivation into plantation mode. ",
    "These are the two points to which Ghosh returns through examples from around the world. ",
    "One, how European colonialists decimated not only indigenous populations but also indigenous understanding of the relationship between humans and Earth. ",
    "Two, how this was an invasion not only of humans but of the Earth itself, and how this continues to the present day by looking at nature as a 'resource' to exploit. ",
    "We know we are facing more frequent and more severe heatwaves, storms, floods, droughts and wildfires due to climate change. ",
    "We know our expansion through deforestation, dam building, canal cutting – in short, terraforming, the word Ghosh uses – has brought us repeated disasters . . . ",
    // End of Paragraph 2
    "Are these the responses of an angry Gaia who has finally had enough? ",
    "By using the word 'curse' in the title, the author makes it clear that he thinks so. ",
    "I use the pronoun 'who' knowingly, because Ghosh has quoted many non-European sources to enquire into the relationship between humans and the world around them so that he can question the prevalent way of looking at Earth as an inert object to be exploited to the maximum. ",
    "As Ghosh's text, notes and bibliography show once more, none of this is new. ",
    "There have always been challenges to the way European colonialists looked at other civilisations and at Earth. ",
    "It is just that the invaders and their myriad backers in the fields of economics, politics, anthropology, philosophy, literature, technology, physics, chemistry, biology have dominated global intellectual discourse. . . . ",
    // End of Paragraph 3 (part 1)
    "There are other points of view that we can hear today if we listen hard enough. ",
    "Those observing global climate negotiations know about the Latin American way of looking at Earth as Pachamama (Earth Mother). ",
    "They also know how such a framing is just provided lip service and is ignored in the substantive portions of the negotiations. ",
    "In The Nutmeg's Curse, Ghosh explains why. ",
    "He shows the extent of the vested interest in the oil economy – not only for oil-exporting countries, but also for a superpower like the US that controls oil drilling, oil prices and oil movement around the world. ",
    "Many of us know power utilities are sabotaging decentralised solar power generation today because it hits their revenues and control. ",
    "And how the other points of view are so often drowned out. "
  ];

  // State for each sentence: 0: none, 1: essence (green), 2: relevant (yellow), 3: irrelevant (red)
  late List<int> selections;
  bool submitted = false;
  int score = 0;

  // Dummy "correct" classification (adjust these as needed).
  final List<int> correctClassification = [
    1, 2, 1, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2,
  ];

  // Gist summarizing the passage.
  final String gist =
      "Gist: 'The Nutmeg’s Curse' argues that the origins of the modern climate crisis lie far before the Industrial Age—rooted in European colonialism. The book contends that colonial violence and exploitation not only decimated indigenous populations and their environmental wisdom, but also disrupted the natural relationship between humans and Earth, setting the stage for today’s environmental challenges.";

  @override
  void initState() {
    super.initState();
    selections = List.filled(sentences.length, 0);
  }

  // Cycle through selection states when a sentence is tapped.
  void _cycleSelection(int index) {
    if (!submitted) {
      setState(() {
        selections[index] = (selections[index] + 1) % 4;
      });
    }
  }

  // Return the background color based on the user's selection.
  Color _getColor(int selection) {
    switch (selection) {
      case 1:
        return Colors.green.withOpacity(0.3);
      case 2:
        return Colors.yellow.withOpacity(0.3);
      case 3:
        return Colors.red.withOpacity(0.3);
      default:
        return Colors.transparent;
    }
  }

  // Return a slightly brighter version for underlining (if selection is wrong).
  Color _getBrighterColor(int classification) {
    switch (classification) {
      case 1:
        return Colors.greenAccent;
      case 2:
        return Colors.yellowAccent;
      case 3:
        return Colors.redAccent;
      default:
        return Colors.transparent;
    }
  }

  // Build the passage as a continuous block with paragraph breaks.
  List<TextSpan> _buildPassageSpans() {
    List<TextSpan> spans = [];
    for (int i = 0; i < sentences.length; i++) {
      spans.add(
        TextSpan(
          text: sentences[i],
          style: TextStyle(
            fontSize: 16,
            backgroundColor: _getColor(selections[i]),
            // When submitted and if incorrect, underline with the brighter color.
            decoration: (submitted && selections[i] != correctClassification[i])
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: (submitted && selections[i] != correctClassification[i])
                ? _getBrighterColor(correctClassification[i])
                : null,
            decorationThickness: (submitted && selections[i] != correctClassification[i])
                ? 2.0
                : 0,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _cycleSelection(i),
        ),
      );
      // Insert paragraph breaks after indices 3 and 9.
      if (i == 3 || i == 9) {
        spans.add(TextSpan(text: "\n\n", style: TextStyle(fontSize: 16)));
      }
    }
    return spans;
  }

  // Build an icon-based legend (non-textual) for the three color codes.
  Widget _buildIconLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Essence: Green Check Circle
        Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
          ],
        ),
        // Relevant: Yellow Info
        Column(
          children: [
            Icon(Icons.info, color: Colors.yellow[700], size: 32),
          ],
        ),
        // Irrelevant: Red Cancel
        Column(
          children: [
            Icon(Icons.cancel, color: Colors.red, size: 32),
          ],
        ),
      ],
    );
  }

  // When the user submits their selections, mark as submitted, calculate the score.
  void _assessSelections() {
    setState(() {
      submitted = true;
      score = 0;
      for (int i = 0; i < selections.length; i++) {
        if (selections[i] == correctClassification[i]) {
          score++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interactive Passage Feedback"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: RichText(
                text: TextSpan(
                  children: _buildPassageSpans(),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Divider(),
          // Icon-based legend instead of text-based
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _buildIconLegend(),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: submitted ? null : _assessSelections,
              child: Text("Submit Selections"),
            ),
          ),
          // When submitted, show the score and gist at the bottom.
          if (submitted)
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              color: Colors.grey.shade200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Score: $score out of ${sentences.length}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(gist, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
