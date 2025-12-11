import 'package:flutter/material.dart';
import 'package:mathhammer/widgets/unit_card_base.dart';
import '../models/unit_stats.dart';
import 'package:mathhammer/simulation/sim.dart';
import '../simulation/weapon_profiles.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:mathhammer/settings_manager.dart';
import 'package:provider/provider.dart';


class SimulationPage extends StatefulWidget {
  final Unit? unit1;
  final Unit? unit2;
  final Function(int) onClearSlot;
  final VoidCallback onNavigateToLibrary;

  const SimulationPage({
    super.key,
    this.unit1,
    this.unit2,
    required this.onClearSlot,
    required this.onNavigateToLibrary,
  });

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  String selectedWeaponIdUnit1 = 'standard_ranged';
  String selectedWeaponIdUnit2 = 'standard_ranged';
  int numSimulations = 1000;
  Sim? _lastSimulation;
  bool _isRunning = false;

  static final List<ap.AudioPlayer> _lowLatencyPlayers = [];
  static const int _maxLowLatencyPlayers = 5;
  static int _currentPlayerIndex = 0;

  static Future<ap.AudioPlayer> _getLowLatencyPlayer() async {
    if (_lowLatencyPlayers.length < _maxLowLatencyPlayers) {
      final newPlayer = ap.AudioPlayer();
      _lowLatencyPlayers.add(newPlayer);
      return newPlayer;
    }
    final player = _lowLatencyPlayers[_currentPlayerIndex];
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _maxLowLatencyPlayers; 
    return player;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Simulation',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (widget.unit1 != null || widget.unit2 != null)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      widget.onClearSlot(1);
                      widget.onClearSlot(2);
                      setState(() {
                        selectedWeaponIdUnit1 = 'standard_ranged';
                        selectedWeaponIdUnit2 = 'standard_ranged';
                        _lastSimulation = null;
                      });
                    },
                  ),
              ],
            ),
          ),

          // Unit selection cards
          SizedBox(
            height: 350,
            child: Row(
              children: [
                Expanded(child: _buildSlot(context, widget.unit1, 1)),
                Expanded(child: _buildSlot(context, widget.unit2, 2)),
              ],
            ),
          ),

          // Simulation controls
          if (widget.unit1 != null && widget.unit2 != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text('Number of Simulations: $numSimulations', style: Theme.of(context).textTheme.titleMedium),
                  Slider(
                    value: numSimulations.toDouble(),
                    min: 10,
                    max: 1000,
                    divisions: 99,
                    label: numSimulations.toString(),
                    onChanged: (value) {
                      setState(() {
                        numSimulations = value.toInt();
                        _lastSimulation = null; // Clear previous results when changing simulation count
                      });
                    },
                    secondaryActiveColor: Color.fromARGB(255, 69, 69, 69),
                  ),
                  const SizedBox(height: 8),
                  _isRunning
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: () {
                            final settingsManager = Provider.of<SettingsManager>(context, listen: false);
                            if (settingsManager.soundEnabled) {
                              _getLowLatencyPlayer().then((player) => 
                              player.play(ap.AssetSource('sounds/For the emperor.mp3')));
                            }
                            _runSimulation();
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Run Simulation'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                        ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

          // Results section
          if (_lastSimulation != null) _buildResults(),
        ],
      ),
    );
  }

  Widget _buildSlot(BuildContext context, Unit? unit, int slotNumber) {
    if (unit == null) {
      return Card(
        margin: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: widget.onNavigateToLibrary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline_sharp, size: 64, color: Colors.grey),
              const SizedBox(height: 8),
              Text('Select Unit $slotNumber', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    final selectedWeaponId = slotNumber == 1 ? selectedWeaponIdUnit1 : selectedWeaponIdUnit2;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: UnitCardBase(unit: unit, onReturn: () {}),
            ),
          ),

          // Weapon selection dropdown
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Weapon:', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 4),
                DropdownButton<String>(  // weapon selection
                  isExpanded: true,
                  value: selectedWeaponId,
                  items: WeaponProfiles.allProfiles.map((weapon) {
                    return DropdownMenuItem(
                      value: weapon.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(weapon.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            'A:${weapon.attacks}, S:${weapon.strength}, AP:${weapon.ap}, D:${weapon.damage}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        if (slotNumber == 1) {
                          selectedWeaponIdUnit1 = value;
                        } else {
                          selectedWeaponIdUnit2 = value;
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final avgResults = _lastSimulation!.getAverageResults(numSimulations);
    final unitAResults = avgResults['unitA'] as Map<String, dynamic>;
    final unitBResults = avgResults['unitB'] as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Simulation Results', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Simulations Run: $numSimulations'),
                  Text("${_lastSimulation!.unitA.name}'s Weapon: ${_lastSimulation!.weaponA.name}"),
                  Text("${_lastSimulation!.unitB.name}'s Weapon: ${_lastSimulation!.weaponB.name}"),
                  const SizedBox(height: 16),
                  _buildWinnerSummary(context, unitAResults, unitBResults),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Unit A Results
          _buildUnitResults(
            context,
            unitAResults['name'],
            _lastSimulation!.resultsA,
            unitAResults,
            _lastSimulation!.weaponA,
          ),
          const SizedBox(height: 16),

          // Unit B Results
          _buildUnitResults(
            context,
            unitBResults['name'],
            _lastSimulation!.resultsB,
            unitBResults,
            _lastSimulation!.weaponB,
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerSummary(
    BuildContext context,
    Map<String, dynamic> unitA,
    Map<String, dynamic> unitB,
  ) {
    final damageA = double.parse(unitA['avgDamageDealt']);
    final damageB = double.parse(unitB['avgDamageDealt']);
    final killedA = double.parse(unitA['avgModelsKilled']);
    final killedB = double.parse(unitB['avgModelsKilled']);

    String winner;
    Color winnerColor;

    if (killedA > killedB) {
      winner = '${unitA['name']} killed ${killedA.toStringAsFixed(2)} models on average vs ${killedB.toStringAsFixed(2)}!';
      winnerColor = Colors.green;
    } else if (killedB > killedA) {
      winner ='${unitB['name']} killed ${killedB.toStringAsFixed(2)} models on average vs ${killedA.toStringAsFixed(2)}!';
      winnerColor = Colors.orange;
    } else if (damageA > damageB) {
      winner = '${unitA['name']} deals more damage on average!';
      winnerColor = Colors.green;
    } else if (damageB > damageA) {
      winner = '${unitB['name']} deals more damage on average!';
      winnerColor = Colors.orange;
    } else {
      winner = 'Both units perform equally!';
      winnerColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: winnerColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: winnerColor, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.emoji_events, color: winnerColor, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              winner,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: winnerColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitResults(
    BuildContext context,
    String unitName,
    UnitSimulationResults results,
    Map<String, dynamic> avgResults,
    dynamic weapon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              unitName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (weapon.keywords.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Wrap(
                  spacing: 4,
                  children: weapon.keywords.map<Widget>((k) {
                    return Chip(
                      label: Text(
                        _formatKeyword(k.toString().split('.').last),
                        style: const TextStyle(fontSize: 10),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),
              ),
            const Divider(),
            const SizedBox(height: 8),

            // Total Results
            Text(
              'Total Results:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildStatRow('Total Hits', results.totalHits),
            _buildStatRow('Total Misses', results.totalMisses),
            _buildStatRow('Critical Hits', results.totalCriticalHits),
            _buildStatRow('Total Wounds Inflicted', results.totalGivenWounds),
            _buildStatRow('Critical Wounds', results.totalCriticalWounds),
            _buildStatRow('Total Damage Dealt', results.totalDamage),
            _buildStatRow('Models Killed', results.modelsKilled),

            const SizedBox(height: 16),

            // Average Results
            Text('Average Per Simulation:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildStatRow('Avg Hits', avgResults['avgHits']),
            _buildStatRow('Avg Wounds Inflicted', avgResults['avgWoundsInflicted']),
            _buildStatRow('Avg Damage Dealt', avgResults['avgDamageDealt']),
            _buildStatRow('Avg Models Killed', avgResults['avgModelsKilled']),
            _buildStatRow('Avg Damage Received', avgResults['avgDamageReceived']),
            _buildStatRow('Critical Hit Rate', '${avgResults['criticalHitRate']}%'),

            const SizedBox(height: 16),

            // Hit Rate
            if (results.totalHits + results.totalMisses > 0)
              _buildPercentageBar(
                context,
                'Hit Rate',
                results.totalHits,
                results.totalHits + results.totalMisses,
              ),

            const SizedBox(height: 8),

            // Wound Rate
            if (results.totalHits > 0)
              _buildPercentageBar(
                context,
                'Wound Rate',
                results.totalGivenWounds,
                results.totalHits,
              ),
          ],
        ),
      ),
    );
  }

  String _formatKeyword(String keyword) {
    return keyword.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(0)}',
    ).trim();
  }

  Widget _buildStatRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPercentageBar(
    BuildContext context,
    String label,
    int numerator,
    int denominator,
  ) {
    final percentage = (numerator / denominator * 100).toStringAsFixed(1);
    final ratio = numerator / denominator;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '$percentage%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: ratio,
          minHeight: 8,
          backgroundColor: const Color.fromARGB(255, 134, 134, 134),
        ),
      ],
    );
  }

  void _runSimulation() {
    if (widget.unit1 == null || widget.unit2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select two units for simulation.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get selected weapon profiles
    final weapon1 = WeaponProfiles.getProfileById(selectedWeaponIdUnit1);
    final weapon2 = WeaponProfiles.getProfileById(selectedWeaponIdUnit2);

    if (weapon1 == null || weapon2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Could not load weapon profiles.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isRunning = true;
    });

    // Run simulation with a small delay to show loading indicator
    Future.delayed(const Duration(milliseconds: 1000), () {
      final simulation = Sim(
        unitA: widget.unit1!,
        unitB: widget.unit2!,
        weaponA: weapon1,
        weaponB: weapon2,
      );

      simulation.runCombatSim(numSimulations);

      setState(() {
        _lastSimulation = simulation;
        _isRunning = false;
      });

      // Scroll to results
      Future.delayed(const Duration(milliseconds: 100), () {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }
}