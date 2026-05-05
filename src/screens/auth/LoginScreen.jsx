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
import { validateEmail, validatePassword } from '../../utils/validators';

const LoginScreen = ({ navigation }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const [toast, setToast] = useState({ visible: false, message: '', type: 'info' });
  const { login } = useAuth();

  const handleLogin = async () => {
    const newErrors = {};
    if (!validateEmail(email)) {
      newErrors.email = 'Please enter a valid email';
    }
    if (!validatePassword(password)) {
      newErrors.password = 'Password must be at least 6 characters';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    setErrors({});
    setLoading(true);

    const result = await login(email, password);
    setLoading(false);

    if (!result.success) {
      setToast({ visible: true, message: result.error, type: 'error' });
    }
  };

  const handleDemoLogin = () => {
    setEmail('demo@consumer.com');
    setPassword('demo123');
    setTimeout(() => {
      handleLogin();
    }, 100);
  };

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <View style={styles.header}>
          <Text style={styles.title}>Welcome to IndEase</Text>
          <Text style={styles.subtitle}>Login to continue</Text>
        </View>

        <View style={styles.form}>
          <InputField
            label="Email"
            value={email}
            onChangeText={setEmail}
            placeholder="Enter your email"
            keyboardType="email-address"
            error={errors.email}
          />

          <InputField
            label="Password"
            value={password}
            onChangeText={setPassword}
            placeholder="Enter your password"
            secureTextEntry
            error={errors.password}
          />

          <Button
            title="Login"
            onPress={handleLogin}
            loading={loading}
            style={styles.loginButton}
          />

          <Button
            title="Demo Login"
            onPress={handleDemoLogin}
            variant="secondary"
            style={styles.demoButton}
          />

          <TouchableOpacity
            onPress={() => navigation.navigate('Register')}
            style={styles.registerLink}
          >
            <Text style={styles.registerText}>
              Don't have an account? <Text style={styles.registerBold}>Register</Text>
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
    paddingTop: wp('15%'),
  },
  header: {
    marginBottom: wp('10%'),
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
  loginButton: {
    marginTop: wp('4%'),
  },
  demoButton: {
    marginTop: wp('3%'),
  },
  registerLink: {
    marginTop: wp('6%'),
    alignItems: 'center',
  },
  registerText: {
    fontSize: RFValue(14),
    color: colors.textSecondary,
  },
  registerBold: {
    fontWeight: '700',
    color: colors.primary,
  },
});

export default LoginScreen;
