import React, { useState } from 'react';
import { ScrollView, View, Text, TextInput, StyleSheet, Button } from 'react-native';
import Checkbox from 'expo-checkbox';
import { Picker } from '@react-native-picker/picker';
import { ALL_PRIORITIES, ChildProfile, DailyLimits, Priority, Temperament } from '../types';
import { useApp } from '../context/AppContext';
import { v4 as uuidv4 } from 'uuid';

export default function OnboardingScreen() {
  const { generatePlanFromProfile } = useApp();
  const [name, setName] = useState('');
  const [age, setAge] = useState<string>('2');
  const [temperament, setTemperament] = useState<Temperament>('Curious');
  const [priorities, setPriorities] = useState<Record<Priority, boolean>>({
    'Physical Activity': true,
    'Cognitive Skills': false,
    'Emotional Regulation': false,
    'Creativity': false,
  });
  const [limits, setLimits] = useState<DailyLimits>({
    screenTimeMinutes: 60,
    treatsPerDay: 1,
    minActivityMinutes: 30,
  });

  const canSubmit = name.trim().length > 0 && Number(age) >= 2;

  const submit = () => {
    if (!canSubmit) return;
    const profile: ChildProfile = {
      id: uuidv4(),
      name: name.trim(),
      age: Number(age),
      temperament,
      priorities: ALL_PRIORITIES.filter((p) => priorities[p]),
      dailyLimits: limits,
    };
    generatePlanFromProfile(profile);
  };

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>Parent Setup</Text>

      <Text style={styles.label}>Child’s Name</Text>
      <TextInput style={styles.input} value={name} onChangeText={setName} placeholder="e.g., Maya" />

      <Text style={styles.label}>Child’s Age</Text>
      <TextInput style={styles.input} keyboardType="number-pad" value={age} onChangeText={setAge} />

      <Text style={styles.label}>Child’s Temperament</Text>
      <View style={styles.pickerWrap}>
        <Picker selectedValue={temperament} onValueChange={(v) => setTemperament(v)}>
          <Picker.Item label="Calm" value="Calm" />
          <Picker.Item label="Energetic" value="Energetic" />
          <Picker.Item label="Sensitive" value="Sensitive" />
          <Picker.Item label="Curious" value="Curious" />
        </Picker>
      </View>

      <Text style={styles.section}>Parent’s development priorities</Text>
      {ALL_PRIORITIES.map((p) => (
        <View key={p} style={styles.row}>
          <Checkbox value={priorities[p]} onValueChange={(v) => setPriorities((prev) => ({ ...prev, [p]: v }))} />
          <Text style={styles.rowText}>{p}</Text>
        </View>
      ))}

      <Text style={styles.section}>Daily limits</Text>
      <Text style={styles.label}>Screen time (minutes)</Text>
      <TextInput
        style={styles.input}
        keyboardType="number-pad"
        value={String(limits.screenTimeMinutes)}
        onChangeText={(t) => setLimits((l) => ({ ...l, screenTimeMinutes: Number(t || '0') }))}
      />

      <Text style={styles.label}>Treats / sweets (count)</Text>
      <TextInput
        style={styles.input}
        keyboardType="number-pad"
        value={String(limits.treatsPerDay)}
        onChangeText={(t) => setLimits((l) => ({ ...l, treatsPerDay: Number(t || '0') }))}
      />

      <Text style={styles.label}>Minimum daily activity (minutes)</Text>
      <TextInput
        style={styles.input}
        keyboardType="number-pad"
        value={String(limits.minActivityMinutes)}
        onChangeText={(t) => setLimits((l) => ({ ...l, minActivityMinutes: Number(t || '0') }))}
      />

      <Button title="Generate Weekly Development Plan" onPress={submit} disabled={!canSubmit} />
      <View style={{ height: 24 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { padding: 16 },
  title: { fontSize: 24, fontWeight: '600', marginBottom: 16 },
  section: { marginTop: 16, fontSize: 18, fontWeight: '600' },
  label: { marginTop: 12, marginBottom: 4, fontWeight: '500' },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    padding: 12,
  },
  row: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 6 },
  rowText: { fontSize: 16 },
  pickerWrap: { borderWidth: 1, borderColor: '#ddd', borderRadius: 8, overflow: 'hidden' },
});
