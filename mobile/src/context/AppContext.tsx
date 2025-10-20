import React, { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import { AppData, ChildProfile, Mood, Note, WeeklyPlan } from '../types';
import { saveJSON, loadJSON, remove } from '../storage/localStorage';
import { generateWeeklyPlan } from '../utils/planGenerator';
import { v4 as uuidv4 } from 'uuid';

const STORAGE_KEY = 'cd.appdata.v1';

export type AppContextValue = {
  data: AppData;
  onboarded: boolean;
  setProfile: (profile: ChildProfile) => void;
  generatePlanFromProfile: (profile: ChildProfile) => void;
  toggleCompletion: (goalId: string, dayIndex: number) => void;
  setMoodForDate: (dateISO: string, mood: Mood) => void;
  addNote: (text: string, mood?: Mood) => void;
  resetWeeklyPlan: () => void;
  updateWeeklyGoals: (updater: (plan: WeeklyPlan) => WeeklyPlan) => void;
  clearAll: () => void;
};

const AppContext = createContext<AppContextValue | undefined>(undefined);

export const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [data, setData] = useState<AppData>({ profile: null, weeklyPlan: null, notes: [], moodByDateISO: {} });
  const onboarded = !!(data.profile && data.weeklyPlan);

  // hydrate
  useEffect(() => {
    (async () => {
      const saved = await loadJSON<AppData>(STORAGE_KEY);
      if (saved) setData(saved);
    })();
  }, []);

  // persist
  useEffect(() => {
    saveJSON(STORAGE_KEY, data).
      catch(() => {/* ignore */});
  }, [data]);

  const setProfile = useCallback((profile: ChildProfile) => {
    setData((prev) => ({ ...prev, profile }));
  }, []);

  const generatePlanFromProfile = useCallback((profile: ChildProfile) => {
    const plan = generateWeeklyPlan(profile);
    setData({ profile, weeklyPlan: plan, notes: [], moodByDateISO: {} });
  }, []);

  const toggleCompletion = useCallback((goalId: string, dayIndex: number) => {
    setData((prev) => {
      if (!prev.weeklyPlan) return prev;
      const current = prev.weeklyPlan.completionsByGoalId[goalId]?.[dayIndex] ?? false;
      const updated = { ...prev.weeklyPlan.completionsByGoalId };
      const arr = [...(updated[goalId] ?? new Array(7).fill(false))];
      arr[dayIndex] = !current;
      updated[goalId] = arr;
      return { ...prev, weeklyPlan: { ...prev.weeklyPlan, completionsByGoalId: updated } };
    });
  }, []);

  const setMoodForDate = useCallback((dateISO: string, mood: Mood) => {
    setData((prev) => ({ ...prev, moodByDateISO: { ...prev.moodByDateISO, [dateISO]: mood } }));
  }, []);

  const addNote = useCallback((text: string, mood?: Mood) => {
    const note: Note = { id: uuidv4(), text, mood, createdAtISO: new Date().toISOString() };
    setData((prev) => ({ ...prev, notes: [note, ...prev.notes] }));
  }, []);

  const resetWeeklyPlan = useCallback(() => {
    setData((prev) => {
      if (!prev.profile) return prev;
      return { ...prev, weeklyPlan: generateWeeklyPlan(prev.profile) };
    });
  }, []);

  const updateWeeklyGoals = useCallback((updater: (plan: WeeklyPlan) => WeeklyPlan) => {
    setData((prev) => ({ ...prev, weeklyPlan: prev.weeklyPlan ? updater(prev.weeklyPlan) : prev.weeklyPlan }));
  }, []);

  const clearAll = useCallback(() => {
    setData({ profile: null, weeklyPlan: null, notes: [], moodByDateISO: {} });
    remove(STORAGE_KEY).catch(() => {/* ignore */});
  }, []);

  const value = useMemo<AppContextValue>(() => ({
    data,
    onboarded,
    setProfile,
    generatePlanFromProfile,
    toggleCompletion,
    setMoodForDate,
    addNote,
    resetWeeklyPlan,
    updateWeeklyGoals,
    clearAll,
  }), [data, onboarded, setProfile, generatePlanFromProfile, toggleCompletion, setMoodForDate, addNote, resetWeeklyPlan, updateWeeklyGoals, clearAll]);

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
};

export function useApp() {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error('useApp must be used within AppProvider');
  return ctx;
}
