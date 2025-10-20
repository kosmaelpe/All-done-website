import React from 'react';
import { ScrollView, View, Text, StyleSheet, Pressable } from 'react-native';
import { useApp } from '../context/AppContext';
import { progressPercent, todayIndex } from '../utils/planGenerator';

export default function WeeklyPlanScreen() {
  const { data, toggleCompletion } = useApp();
  const plan = data.weeklyPlan;
  if (!plan) return (
    <View style={styles.center}><Text>No weekly plan yet.</Text></View>
  );

  const percent = progressPercent(plan);
  const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>Weekly Goals</Text>
      <View style={styles.progressWrap}>
        <View style={[styles.progressBar, { width: `${percent}%` }]} />
      </View>
      <Text style={styles.progressText}>{percent}% completed</Text>

      {plan.goals.map((g) => (
        <View key={g.id} style={styles.card}>
          <Text style={styles.goalTitle}>{g.title}</Text>
          <View style={styles.daysRow}>
            {days.map((d, idx) => {
              const isToday = idx === todayIndex();
              const done = plan.completionsByGoalId[g.id][idx];
              return (
                <Pressable key={d} onPress={() => toggleCompletion(g.id, idx)} style={[styles.day, isToday && styles.today, done && styles.done]}>
                  <Text style={styles.dayText}>{d}</Text>
                </Pressable>
              );
            })}
          </View>
        </View>
      ))}
      <View style={{ height: 24 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { padding: 16 },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 16 },
  title: { fontSize: 24, fontWeight: '600', marginBottom: 12 },
  card: { borderWidth: 1, borderColor: '#eee', borderRadius: 12, padding: 12, marginTop: 12 },
  goalTitle: { fontSize: 16, fontWeight: '600', marginBottom: 8 },
  daysRow: { flexDirection: 'row', justifyContent: 'space-between' },
  day: { paddingVertical: 8, paddingHorizontal: 6, borderRadius: 6, borderWidth: 1, borderColor: '#ddd', minWidth: 40, alignItems: 'center' },
  dayText: { fontSize: 12 },
  today: { borderColor: '#4f46e5' },
  done: { backgroundColor: '#dcfce7', borderColor: '#22c55e' },
  progressWrap: { height: 10, backgroundColor: '#f1f5f9', borderRadius: 999, overflow: 'hidden', marginTop: 8 },
  progressBar: { height: 10, backgroundColor: '#22c55e' },
  progressText: { marginTop: 6, color: '#334155' },
});
