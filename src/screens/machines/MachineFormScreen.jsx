import React, { useState } from 'react';
import {
  View,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  Text,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import { Picker } from '@react-native-picker/picker';
import InputField from '../../components/InputField';
import Button from '../../components/Button';
import Header from '../../components/Header';
import Toast from '../../components/Toast';
import { createMachine, updateMachine } from '../../services/machineService';
import colors from '../../constants/colors';
import { validateRequired } from '../../utils/validators';

const MACHINE_TYPES = [
  'Tractor',
  'Harvester',
  'Plough',
  'Seeder',
  'Sprayer',
  'Cultivator',
  'Other',
];

const MachineFormScreen = ({ navigation, route }) => {
  const machine = route.params?.machine;
  const isEdit = !!machine;

  const [formData, setFormData] = useState({
    name: machine?.name || '',
    type: machine?.type || MACHINE_TYPES[0],
    year: machine?.year?.toString() || '',
  });
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const [toast, setToast] = useState({ visible: false, message: '', type: 'info' });

  const handleChange = (field, value) => {
    setFormData({ ...formData, [field]: value });
    if (errors[field]) {
      setErrors({ ...errors, [field]: '' });
    }
  };

  const handleSubmit = async () => {
    const newErrors = {};

    if (!validateRequired(formData.name)) {
      newErrors.name = 'Machine name is required';
    }
    if (!validateRequired(formData.type)) {
      newErrors.type = 'Machine type is required';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    setErrors({});
    setLoading(true);

    try {
      const data = {
        name: formData.name,
        type: formData.type,
        year: formData.year ? parseInt(formData.year) : undefined,
      };

      if (isEdit) {
        await updateMachine(machine._id || machine.id, data);
        setToast({
          visible: true,
          message: 'Machine updated successfully',
          type: 'success',
        });
      } else {
        await createMachine(data);
        setToast({
          visible: true,
          message: 'Machine added successfully',
          type: 'success',
        });
      }

      setTimeout(() => {
        navigation.goBack();
      }, 1000);
    } catch (error) {
      setToast({
        visible: true,
        message: error.response?.data?.message || 'Failed to save machine',
        type: 'error',
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <Header
        title={isEdit ? 'Edit Machine' : 'Add Machine'}
        onBack={() => navigation.goBack()}
      />

      <ScrollView style={styles.scrollView} contentContainerStyle={styles.content}>
        <InputField
          label="Machine Name"
          value={formData.name}
          onChangeText={(value) => handleChange('name', value)}
          placeholder="e.g., John Deere 5075E"
          error={errors.name}
        />

        <View style={styles.pickerContainer}>
          <Text style={styles.label}>Machine Type</Text>
          <View style={styles.pickerWrapper}>
            <Picker
              selectedValue={formData.type}
              onValueChange={(value) => handleChange('type', value)}
              style={styles.picker}
            >
              {MACHINE_TYPES.map((type) => (
                <Picker.Item key={type} label={type} value={type} />
              ))}
            </Picker>
          </View>
          {errors.type && <Text style={styles.errorText}>{errors.type}</Text>}
        </View>

        <InputField
          label="Year (Optional)"
          value={formData.year}
          onChangeText={(value) => handleChange('year', value)}
          placeholder="e.g., 2020"
          keyboardType="numeric"
        />

        <Button
          title={isEdit ? 'Update Machine' : 'Add Machine'}
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
  pickerContainer: {
    marginBottom: wp('4%'),
  },
  label: {
    fontSize: RFValue(13),
    fontWeight: '600',
    color: colors.textPrimary,
    marginBottom: wp('2%'),
  },
  pickerWrapper: {
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: 12,
    backgroundColor: colors.card,
    overflow: 'hidden',
  },
  picker: {
    height: 50,
  },
  errorText: {
    fontSize: RFValue(11),
    color: colors.error,
    marginTop: wp('1%'),
  },
  submitButton: {
    marginTop: wp('4%'),
  },
});

export default MachineFormScreen;
