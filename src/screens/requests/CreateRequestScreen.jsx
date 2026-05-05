import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
  Platform,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import DateTimePicker from '@react-native-community/datetimepicker';
import { launchImageLibrary } from 'react-native-image-picker';
import Icon from 'react-native-vector-icons/Ionicons';
import InputField from '../../components/InputField';
import Button from '../../components/Button';
import Card from '../../components/Card';
import Header from '../../components/Header';
import Toast from '../../components/Toast';
import { getMachines } from '../../services/machineService';
import { createRequest } from '../../services/requestService';
import { useRequests } from '../../context/RequestContext';
import colors from '../../constants/colors';
import { validateRequired, validateMinLength } from '../../utils/validators';

const URGENCY_LEVELS = [
  { value: 'low', label: 'Low', color: colors.success },
  { value: 'normal', label: 'Normal', color: colors.warning },
  { value: 'critical', label: 'Critical', color: colors.error },
];

const TIME_SLOTS = ['morning', 'afternoon', 'evening', 'anytime'];

const CreateRequestScreen = ({ navigation, route }) => {
  const preselectedMachineId = route.params?.machineId;
  const { addRequest } = useRequests();

  const [machines, setMachines] = useState([]);
  const [selectedMachine, setSelectedMachine] = useState(null);
  const [issueDescription, setIssueDescription] = useState('');
  const [videoUrl, setVideoUrl] = useState('');
  const [urgencyLevel, setUrgencyLevel] = useState('normal');
  const [preferredDate, setPreferredDate] = useState(new Date());
  const [showDatePicker, setShowDatePicker] = useState(false);
  const [preferredTimeSlot, setPreferredTimeSlot] = useState('anytime');
  const [budgetHint, setBudgetHint] = useState('');
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const [toast, setToast] = useState({ visible: false, message: '', type: 'info' });

  useEffect(() => {
    loadMachines();
  }, []);

  const loadMachines = async () => {
    try {
      const data = await getMachines();
      setMachines(data);
      if (preselectedMachineId) {
        const machine = data.find((m) => (m._id || m.id) === preselectedMachineId);
        if (machine) setSelectedMachine(machine);
      }
    } catch (error) {
      setToast({
        visible: true,
        message: 'Failed to load machines',
        type: 'error',
      });
    }
  };

  const handleImagePick = () => {
    launchImageLibrary(
      {
        mediaType: 'mixed',
        quality: 0.8,
      },
      (response) => {
        if (response.assets && response.assets[0]) {
          setVideoUrl(response.assets[0].uri);
        }
      }
    );
  };

  const handleSubmit = async () => {
    const newErrors = {};

    if (!selectedMachine) {
      newErrors.machine = 'Please select a machine';
    }
    if (!validateMinLength(issueDescription, 20)) {
      newErrors.issue = 'Please describe the issue (minimum 20 characters)';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      setToast({
        visible: true,
        message: 'Please fill all required fields',
        type: 'error',
      });
      return;
    }

    setErrors({});
    setLoading(true);

    try {
      const requestData = {
        machineId: selectedMachine._id || selectedMachine.id,
        issueDescription,
        videoUrl: videoUrl || undefined,
        urgencyLevel,
        preferredDate: preferredDate.toISOString(),
        preferredTimeSlot,
        consumerBudgetHint: budgetHint || undefined,
      };

      const newRequest = await createRequest(requestData);
      addRequest(newRequest);

      setToast({
        visible: true,
        message: 'Request created successfully!',
        type: 'success',
      });

      setTimeout(() => {
        navigation.navigate('RequestDetails', {
          requestId: newRequest._id || newRequest.id,
        });
      }, 1000);
    } catch (error) {
      setToast({
        visible: true,
        message: error.response?.data?.message || 'Failed to create request',
        type: 'error',
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <Header title="Create Service Request" onBack={() => navigation.goBack()} />

      <ScrollView style={styles.scrollView} contentContainerStyle={styles.content}>
        <Text style={styles.stepTitle}>Step 1: Select Machine</Text>
        {machines.length === 0 ? (
          <Card style={styles.emptyCard}>
            <Text style={styles.emptyText}>No machines found</Text>
            <Button
              title="Add Machine First"
              onPress={() => navigation.navigate('MachineForm')}
              fullWidth={false}
              style={styles.addMachineButton}
            />
          </Card>
        ) : (
          <View style={styles.machineList}>
            {machines.map((machine) => (
              <TouchableOpacity
                key={machine._id || machine.id}
                onPress={() => setSelectedMachine(machine)}
                style={[
                  styles.machineCard,
                  selectedMachine?._id === machine._id && styles.machineCardSelected,
                ]}
              >
                <Icon
                  name="construct-outline"
                  size={24}
                  color={
                    selectedMachine?._id === machine._id
                      ? colors.primary
                      : colors.textSecondary
                  }
                />
                <View style={styles.machineCardInfo}>
                  <Text style={styles.machineCardName}>{machine.name}</Text>
                  <Text style={styles.machineCardType}>{machine.type}</Text>
                </View>
                {selectedMachine?._id === machine._id && (
                  <Icon name="checkmark-circle" size={24} color={colors.primary} />
                )}
              </TouchableOpacity>
            ))}
          </View>
        )}
        {errors.machine && <Text style={styles.errorText}>{errors.machine}</Text>}

        <Text style={styles.stepTitle}>Step 2: Describe the Issue</Text>
        <InputField
          value={issueDescription}
          onChangeText={setIssueDescription}
          placeholder="Describe the problem in detail (minimum 20 characters)"
          multiline
          numberOfLines={5}
          error={errors.issue}
        />

        <Text style={styles.stepTitle}>Step 3: Upload Media (Optional)</Text>
        <TouchableOpacity onPress={handleImagePick} style={styles.uploadButton}>
          <Icon name="cloud-upload-outline" size={24} color={colors.primary} />
          <Text style={styles.uploadText}>
            {videoUrl ? 'Media Selected' : 'Upload Photo/Video'}
          </Text>
        </TouchableOpacity>

        <Text style={styles.stepTitle}>Step 4: Select Urgency</Text>
        <View style={styles.urgencyContainer}>
          {URGENCY_LEVELS.map((level) => (
            <TouchableOpacity
              key={level.value}
              onPress={() => setUrgencyLevel(level.value)}
              style={[
                styles.urgencyCard,
                urgencyLevel === level.value && {
                  borderColor: level.color,
                  backgroundColor: `${level.color}10`,
                },
              ]}
            >
              <Text
                style={[
                  styles.urgencyLabel,
                  urgencyLevel === level.value && { color: level.color },
                ]}
              >
                {level.label}
              </Text>
            </TouchableOpacity>
          ))}
        </View>

        <Text style={styles.stepTitle}>Step 5: Preferred Date & Time</Text>
        <TouchableOpacity
          onPress={() => setShowDatePicker(true)}
          style={styles.dateButton}
        >
          <Icon name="calendar-outline" size={20} color={colors.primary} />
          <Text style={styles.dateText}>
            {preferredDate.toLocaleDateString('en-IN', {
              year: 'numeric',
              month: 'long',
              day: 'numeric',
            })}
          </Text>
        </TouchableOpacity>

        {showDatePicker && (
          <DateTimePicker
            value={preferredDate}
            mode="date"
            display="default"
            minimumDate={new Date()}
            onChange={(event, date) => {
              setShowDatePicker(Platform.OS === 'ios');
              if (date) setPreferredDate(date);
            }}
          />
        )}

        <View style={styles.timeSlotContainer}>
          {TIME_SLOTS.map((slot) => (
            <TouchableOpacity
              key={slot}
              onPress={() => setPreferredTimeSlot(slot)}
              style={[
                styles.timeSlotButton,
                preferredTimeSlot === slot && styles.timeSlotButtonActive,
              ]}
            >
              <Text
                style={[
                  styles.timeSlotText,
                  preferredTimeSlot === slot && styles.timeSlotTextActive,
                ]}
              >
                {slot.charAt(0).toUpperCase() + slot.slice(1)}
              </Text>
            </TouchableOpacity>
          ))}
        </View>

        <Text style={styles.stepTitle}>Step 6: Budget Hint (Optional)</Text>
        <InputField
          value={budgetHint}
          onChangeText={setBudgetHint}
          placeholder="e.g., ₹2,000 - ₹5,000"
        />

        <Button
          title="Submit Request"
          onPress={handleSubmit}
          loading={loading}
          style={styles.submitButton}
        />
      </ScrollView>

      <Toast
        message={toast.message}
        type={toast.type}
        visible={toast.visible}
        onHide={() => setToast({ ...toast, visible: false })}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  scrollView: {
    flex: 1,
  },
  content: {
    padding: wp('4%'),
  },
  stepTitle: {
    fontSize: RFValue(16),
    fontWeight: '700',
    color: colors.textPrimary,
    marginTop: wp('4%'),
    marginBottom: wp('3%'),
  },
  machineList: {
    gap: wp('2%'),
  },
  machineCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: wp('4%'),
    backgroundColor: colors.card,
    borderRadius: 12,
    borderWidth: 2,
    borderColor: colors.border,
  },
  machineCardSelected: {
    borderColor: colors.primary,
    backgroundColor: `${colors.primary}10`,
  },
  machineCardInfo: {
    flex: 1,
    marginLeft: wp('3%'),
  },
  machineCardName: {
    fontSize: RFValue(15),
    fontWeight: '600',
    color: colors.textPrimary,
  },
  machineCardType: {
    fontSize: RFValue(12),
    color: colors.textSecondary,
    marginTop: wp('1%'),
  },
  emptyCard: {
    alignItems: 'center',
    paddingVertical: wp('6%'),
  },
  emptyText: {
    fontSize: RFValue(14),
    color: colors.textSecondary,
    marginBottom: wp('3%'),
  },
  addMachineButton: {
    paddingHorizontal: wp('6%'),
  },
  uploadButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: wp('4%'),
    backgroundColor: colors.card,
    borderRadius: 12,
    borderWidth: 2,
    borderColor: colors.border,
    borderStyle: 'dashed',
  },
  uploadText: {
    fontSize: RFValue(14),
    color: colors.primary,
    marginLeft: wp('2%'),
    fontWeight: '600',
  },
  urgencyContainer: {
    flexDirection: 'row',
    gap: wp('2%'),
  },
  urgencyCard: {
    flex: 1,
    padding: wp('4%'),
    backgroundColor: colors.card,
    borderRadius: 12,
    borderWidth: 2,
    borderColor: colors.border,
    alignItems: 'center',
  },
  urgencyLabel: {
    fontSize: RFValue(14),
    fontWeight: '600',
    color: colors.textSecondary,
  },
  dateButton: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: wp('4%'),
    backgroundColor: colors.card,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.border,
  },
  dateText: {
    fontSize: RFValue(14),
    color: colors.textPrimary,
    marginLeft: wp('2%'),
  },
  timeSlotContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: wp('2%'),
    marginTop: wp('2%'),
  },
  timeSlotButton: {
    paddingHorizontal: wp('4%'),
    paddingVertical: wp('2%'),
    backgroundColor: colors.card,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: colors.border,
  },
  timeSlotButtonActive: {
    backgroundColor: colors.primary,
    borderColor: colors.primary,
  },
  timeSlotText: {
    fontSize: RFValue(13),
    color: colors.textSecondary,
    fontWeight: '600',
  },
  timeSlotTextActive: {
    color: '#ffffff',
  },
  submitButton: {
    marginTop: wp('6%'),
    marginBottom: wp('4%'),
  },
  errorText: {
    fontSize: RFValue(11),
    color: colors.error,
    marginTop: wp('1%'),
  },
});

export default CreateRequestScreen;
