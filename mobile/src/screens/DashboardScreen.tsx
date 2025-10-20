import React, { useMemo } from 'react';
import { ScrollView, View, Text, StyleSheet, Pressable } from 'react-native';
import { useApp } from '../context/AppContext';
import { tipForToday, todayIndex } from '../utils/planGenerator';

export default function DashboardScreen() {
  const { data, toggleCompletion } = useApp();
  const plan = data.weeklyPlan;
  const profile = data.profile;
  const tip = useMemo(() => tipForToday(profile), [profile]);

  if (!plan || !profile) return (
    <View style={styles.center}><Text>Complete onboarding to see today’s tasks.</Text></View>
  );

  const idx = todayIndex();
  const todays = plan.goals.map((g) => ({ goal: g, done: plan.completionsByGoalId[g.id][idx] }));

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>{profile.name} • {profile.age} yrs</Text>
      <Text style={styles.subtitle}>Today’s tasks</Text>
      {todays.map(({ goal, done }) => (
        <Pressable key={goal.id} onPress={() => toggleCompletion(goal.id, idx)} style={[styles.task, done && styles.done]}>
          <Text style={styles.taskText}>{goal.title}</Text>
        </Pressable>
      ))}

      <View style={styles.tipCard}>
        <Text style={styles.tipTitle}>Tip for today</Text>
        <Text style={styles.tipText}>{tip}</Text>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { padding: 16 },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 16 },
  title: { fontSize: 24, fontWeight: '700' },
  subtitle: { marginTop: 12, marginBottom: 8, fontWeight: '600' },
  task: { padding: 12, borderWidth: 1, borderColor: '#eee', borderRadius: 12, marginBottom: 8 },
  taskText: { fontSize: 16 },
  done: { backgroundColor: '#dcfce7', borderColor: '#22c55e' },
  tipCard: { marginTop: 16, borderWidth: 1, borderColor: '#e5e7eb', borderRadius: 12, padding: 12, backgroundColor: '#f8fafc' },
  tipTitle: { fontWeight: '700', marginBottom: 6 },
  tipText: { color: '#334155' },
});
