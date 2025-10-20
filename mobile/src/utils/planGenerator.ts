import { addDays, startOfWeek, formatISO } from 'date-fns';
import { Priority, ChildProfile, WeeklyGoal, WeeklyPlan } from '../types';
import { v4 as uuidv4 } from 'uuid';

const PRIORITY_TO_GOALS: Record<Priority, () => WeeklyGoal[]> = {
  'Physical Activity': () => [
    { id: uuidv4(), title: '30 min physical activity', kind: 'physical' },
    { id: uuidv4(), title: 'Family walk after dinner', kind: 'physical' },
  ],
  'Cognitive Skills': () => [
    { id: uuidv4(), title: '15 min reading with parent', kind: 'reading' },
    { id: uuidv4(), title: 'Play a counting game', kind: 'cognitive' },
  ],
  'Emotional Regulation': () => [
    { id: uuidv4(), title: '2x daily calm-breathing (3 breaths)', kind: 'emotion' },
    { id: uuidv4(), title: 'Name one feeling at bedtime', kind: 'emotion' },
  ],
  'Creativity': () => [
    { id: uuidv4(), title: '10 min drawing or building', kind: 'creativity' },
    { id: uuidv4(), title: 'Music & movement session', kind: 'creativity' },
  ],
};

function uniqueGoals(goals: WeeklyGoal[]): WeeklyGoal[] {
  const seen = new Set<string>();
  const result: WeeklyGoal[] = [];
  for (const g of goals) {
    const key = g.title.toLowerCase();
    if (!seen.has(key)) {
      seen.add(key);
      result.push(g);
    }
  }
  return result;
}

export function generateWeeklyPlan(profile: ChildProfile): WeeklyPlan {
  const weekStart = startOfWeek(new Date(), { weekStartsOn: 1 }); // Monday
  let goals: WeeklyGoal[] = [];

  for (const p of profile.priorities) {
    goals = goals.concat(PRIORITY_TO_GOALS[p]());
  }

  // Always include a screen hygiene goal based on limit
  goals.push({ id: uuidv4(), title: 'No screens after 6 PM', kind: 'screens' });

  goals = uniqueGoals(goals).slice(0, 5); // keep 3-5 goals

  const completionsByGoalId: Record<string, boolean[]> = {};
  for (const g of goals) {
    completionsByGoalId[g.id] = new Array(7).fill(false);
  }

  return {
    id: uuidv4(),
    weekStartISO: formatISO(weekStart, { representation: 'date' }),
    goals,
    completionsByGoalId,
  };
}

export function progressPercent(plan: WeeklyPlan): number {
  const total = plan.goals.length * 7;
  const done = plan.goals.reduce((acc, g) => acc + plan.completionsByGoalId[g.id].filter(Boolean).length, 0);
  return total === 0 ? 0 : Math.round((done / total) * 100);
}

export function todayIndex(): number {
  // Monday=0 .. Sunday=6
  const day = new Date().getDay(); // Sun=0..Sat=6
  return day === 0 ? 6 : day - 1;
}

export function tipForToday(profile: ChildProfile | null): string {
  const base = [
    'You are your child’s favorite teacher. Short, frequent moments matter.',
    'Routine builds security. Keep tasks predictable and playful.',
    'Name emotions out loud to help your child learn self-regulation.',
    'Movement boosts focus. A quick dance counts!',
    'Screens off before dinner helps with sleep quality.',
  ];
  if (!profile) return base[0];
  if (profile.priorities.includes('Physical Activity')) return 'Try a 1-song dance party 🎶 to meet activity goals.';
  if (profile.priorities.includes('Cognitive Skills')) return 'Point and count objects during cleanup to build numeracy.';
  if (profile.priorities.includes('Emotional Regulation')) return 'Practice 3 calm breaths together before bedtime.';
  if (profile.priorities.includes('Creativity')) return 'Offer two choices: crayons or blocks to spark creativity.';
  return base[1];
}
