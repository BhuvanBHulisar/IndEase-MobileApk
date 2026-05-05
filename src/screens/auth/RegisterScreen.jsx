import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import InputField from '../../components/InputField';
import Button from '../../components/Button';
import Toast from '../../components/Toast';
import { useAuth } from '../../context/AuthContext';
import colors from '../../constants/colors';
import {
  validateEmail,
  validatePassword,
  validateRequired,
} from '../../utils/validators';

const RegisterScreen = ({ navigation }) => {
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    password: '',
    confirmPassword: '',
  });
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const [toast, setToast] = useState({ visible: false, message: '', type: 'info' });
  const { register } = useAuth();

  const handleChange = (field, value) => {
    setFormData({ ...formData, [field]: value });
    if (errors[field]) {
      setErrors({ ...errors, [field]: '' });
    }
  };

  const handleRegister = async () => {
    const newErrors = {};

    if (!validateRequired(formData.firstName)) {
      newErrors.firstName = 'First name is required';
    }
    if (!validateRequired(formData.lastName)) {
      newErrors.lastName = 'Last name is required';
    }
    if (!validateEmail(formData.email)) {
      newErrors.email = 'Please enter a valid email';
    }
    if (!validatePassword(formData.password)) {
      newErrors.password = 'Password must be at least 6 characters';
    }
    if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = 'Passwords do not match';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    setErrors({});
    setLoading(true);

    const result = await register({
      firstName: formData.firstName,
      lastName: formData.lastName,
      email: formData.email,
      password: formData.password,
    });

    setLoading(false);

    if (!result.success) {
      setToast({ visible: true, message: result.error, type: 'error' });
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <View style={styles.header}>
          <Text style={styles.title}>Create Account</Text>
          <Text style={styles.subtitle}>Join IndEase as a Consumer</Text>
        </View>

        <View style={styles.form}>
          <InputField
            label="First Name"
            value={formData.firstName}
            onChangeText={(value) => handleChange('firstName', value)}
            placeholder="Enter your first name"
            error={errors.firstName}
          />

          <InputField
            label="Last Name"
            value={formData.lastName}
            onChangeText={(value) => handleChange('lastName', value)}
            placeholder="Enter your last name"
            error={errors.lastName}
          />

          <InputField
            label="Email"
            value={formData.email}
            onChangeText={(value) => handleChange('email', value)}
            placeholder="Enter your email"
            keyboardType="email-address"
            error={errors.email}
          />

          <InputField
            label="Password"
            value={formData.password}
            onChangeText={(value) => handleChange('password', value)}
            placeholder="Enter your password"
            secureTextEntry
            error={errors.password}
          />

          <InputField
            label="Confirm Password"
            value={formData.confirmPassword}
            onChangeText={(value) => handleChange('confirmPassword', value)}
            placeholder="Confirm your password"
            secureTextEntry
            error={errors.confirmPassword}
          />

          <Button
            title="Register"
            onPress={handleRegister}
            loading={loading}
            style={styles.registerButton}
          />

          <TouchableOpacity
            onPress={() => navigation.navigate('Login')}
            style={styles.loginLink}
          >
            <Text style={styles.loginText}>
              Already have an account? <Text style={styles.loginBold}>Login</Text>
            </Text>
          </TouchableOpacity>
        </View>
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
  scrollContent: {
    flexGrow: 1,
    paddingHorizontal: wp('6%'),
    paddingTop: wp('10%'),
  },
  header: {
    marginBottom: wp('8%'),
  },
  title: {
    fontSize: RFValue(28),
    fontWeight: '700',
    color: colors.textPrimary,
    marginBottom: wp('2%'),
  },
  subtitle: {
    fontSize: RFValue(16),
    color: colors.textSecondary,
  },
  form: {
    flex: 1,
  },
  registerButton: {
    marginTop: wp('4%'),
  },
  loginLink: {
    marginTop: wp('6%'),
    alignItems: 'center',
  },
  loginText: {
    fontSize: RFValue(14),
    color: colors.textSecondary,
  },
  loginBold: {
    fontWeight: '700',
    color: colors.primary,
  },
});

export default RegisterScreen;
