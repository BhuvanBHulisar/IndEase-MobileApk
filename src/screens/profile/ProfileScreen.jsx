import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import Icon from 'react-native-vector-icons/Ionicons';
import Card from '../../components/Card';
import { useAuth } from '../../context/AuthContext';
import { useRequests } from '../../context/RequestContext';
import colors from '../../constants/colors';

const ProfileScreen = ({ navigation }) => {
  const { user, logout } = useAuth();
  const { requests, activeRequests } = useRequests();

  const completedRequests = requests.filter((r) => r.status === 'completed').length;

  const handleLogout = () => {
    Alert.alert('Logout', 'Are you sure you want to logout?', [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Logout',
        style: 'destructive',
        onPress: async () => {
          await logout();
        },
      },
    ]);
  };

  const MenuItem = ({ icon, title, onPress, color = colors.textPrimary }) => (
    <TouchableOpacity onPress={onPress} style={styles.menuItem}>
      <View style={styles.menuLeft}>
        <Icon name={icon} size={22} color={color} />
        <Text style={[styles.menuText, { color }]}>{title}</Text>
      </View>
      <Icon name="chevron-forward" size={20} color={colors.textSecondary} />
    </TouchableOpacity>
  );

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.scrollView}>
        <View style={styles.header}>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>
              {user?.firstName?.[0]}{user?.lastName?.[0]}
            </Text>
          </View>
          <Text style={styles.name}>
            {user?.firstName} {user?.lastName}
          </Text>
          <Text style={styles.email}>{user?.email}</Text>
          <View style={styles.roleBadge}>
            <Text style={styles.roleText}>Consumer</Text>
          </View>
        </View>

        <View style={styles.statsContainer}>
          <Card style={styles.statCard}>
            <Text style={styles.statValue}>{requests.length}</Text>
            <Text style={styles.statLabel}>Total Requests</Text>
          </Card>
          <Card style={styles.statCard}>
            <Text style={styles.statValue}>{completedRequests}</Text>
            <Text style={styles.statLabel}>Completed</Text>
          </Card>
          <Card style={styles.statCard}>
            <Text style={styles.statValue}>{activeRequests.length}</Text>
            <Text style={styles.statLabel}>Active</Text>
          </Card>
        </View>

        <Card style={styles.menuCard}>
          <MenuItem
            icon="person-outline"
            title="Edit Profile"
            onPress={() => navigation.navigate('EditProfile')}
          />
          <MenuItem
            icon="lock-closed-outline"
            title="Change Password"
            onPress={() => navigation.navigate('ChangePassword')}
          />
          <MenuItem
            icon="notifications-outline"
            title="Notifications"
            onPress={() => navigation.navigate('Notifications')}
          />
          <MenuItem
            icon="help-circle-outline"
            title="Help & Support"
            onPress={() => {}}
          />
          <MenuItem
            icon="document-text-outline"
            title="Terms & Privacy"
            onPress={() => {}}
          />
          <MenuItem
            icon="log-out-outline"
            title="Logout"
            onPress={handleLogout}
            color={colors.error}
          />
        </Card>

        <Text style={styles.version}>Version 1.0.0</Text>
      </ScrollView>
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
  header: {
    alignItems: 'center',
    paddingVertical: wp('8%'),
    backgroundColor: colors.card,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: wp('3%'),
  },
  avatarText: {
    fontSize: RFValue(28),
    fontWeight: 'bold',
    color: '#ffffff',
  },
  name: {
    fontSize: RFValue(20),
    fontWeight: '700',
    color: colors.textPrimary,
    marginBottom: wp('1%'),
  },
  email: {
    fontSize: RFValue(14),
    color: colors.textSecondary,
    marginBottom: wp('2%'),
  },
  roleBadge: {
    paddingHorizontal: wp('4%'),
    paddingVertical: wp('1.5%'),
    backgroundColor: `${colors.primary}20`,
    borderRadius: 20,
  },
  roleText: {
    fontSize: RFValue(12),
    fontWeight: '600',
    color: colors.primary,
  },
  statsContainer: {
    flexDirection: 'row',
    paddingHorizontal: wp('4%'),
    paddingVertical: wp('4%'),
    gap: wp('3%'),
  },
  statCard: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: wp('4%'),
  },
  statValue: {
    fontSize: RFValue(24),
    fontWeight: '700',
    color: colors.primary,
    marginBottom: wp('1%'),
  },
  statLabel: {
    fontSize: RFValue(11),
    color: colors.textSecondary,
    textAlign: 'center',
  },
  menuCard: {
    marginHorizontal: wp('4%'),
    marginBottom: wp('4%'),
  },
  menuItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: wp('4%'),
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  menuLeft: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  menuText: {
    fontSize: RFValue(15),
    marginLeft: wp('3%'),
    fontWeight: '500',
  },
  version: {
    fontSize: RFValue(12),
    color: colors.textSecondary,
    textAlign: 'center',
    marginBottom: wp('6%'),
  },
});

export default ProfileScreen;
