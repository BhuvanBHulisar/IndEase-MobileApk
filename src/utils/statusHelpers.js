import colors from '../constants/colors';

export const STATUS_LABELS = {
  broadcast: 'Searching for Experts',
  quote_submitted: 'Quotes Ready',
  quote_approved: 'Expert Confirmed',
  en_route: 'Expert On The Way',
  in_progress: 'Repair In Progress',
  pending_confirmation: 'Please Confirm',
  completed: 'Completed',
  cancelled: 'Cancelled',
};

export const getStatusLabel = (status) => {
  return STATUS_LABELS[status] || status;
};

export const getStatusColor = (status) => {
  return colors.statusColors[status] || colors.textSecondary;
};

export const getActionButton = (status) => {
  const actions = {
    broadcast: { label: 'Cancel Request', type: 'danger' },
    quote_submitted: { label: 'View Quotes', type: 'primary', pulse: true },
    quote_approved: { label: 'Open Chat', type: 'secondary' },
    en_route: { label: 'Open Chat', type: 'secondary' },
    in_progress: { label: 'Open Chat', type: 'secondary' },
    pending_confirmation: { label: 'Confirm Complete', type: 'success', prominent: true },
    completed: { label: 'Rate Expert', type: 'primary' },
  };
  return actions[status] || null;
};

export const getProgressStep = (status) => {
  const steps = {
    broadcast: 0,
    quote_submitted: 1,
    quote_approved: 2,
    en_route: 2,
    in_progress: 3,
    pending_confirmation: 3,
    completed: 4,
    cancelled: 0,
  };
  return steps[status] || 0;
};
