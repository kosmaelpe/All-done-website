export type Temperament = 'Calm' | 'Energetic' | 'Sensitive' | 'Curious';

export type Priority =
  | 'Physical Activity'
  | 'Cognitive Skills'
  | 'Emotional Regulation'
  | 'Creativity';

export const ALL_PRIORITIES: Priority[] = [
  'Physical Activity',
  'Cognitive Skills',
  'Emotional Regulation',
  'Creativity',
];

export type DailyLimits = {
  screenTimeMinutes: number; // per day
  treatsPerDay: number; // count
  minActivityMinutes: number; // per day
};

export type ChildProfile = {
  id: string;
  name: string;
  age: number; // in years
  temperament: Temperament;
  priorities: Priority[];
  dailyLimits: DailyLimits;
};

export type WeeklyGoal = {
  id: string;
  title: string;
  kind:
    | 'reading'
    | 'physical'
    | 'screens'
    | 'creativity'
    | 'emotion'
    | 'cognitive'
    | 'routine';
  description?: string;
};

export type WeeklyPlan = {
  id: string;
  weekStartISO: string; // Monday of the week
  goals: WeeklyGoal[];
  // For each goal, 7 booleans (Mon..Sun)
  completionsByGoalId: Record<string, boolean[]>;
};

export type Mood = 'happy' | 'neutral' | 'sad';

export type Note = {
  id: string;
  text: string;
  createdAtISO: string;
  mood?: Mood;
  author?: string; // optional for future multi-user
};

export type AppData = {
  profile: ChildProfile | null;
  weeklyPlan: WeeklyPlan | null;
  notes: Note[];
  moodByDateISO: Record<string, Mood>;
};
