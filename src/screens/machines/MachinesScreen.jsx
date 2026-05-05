import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  FlatList,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import Icon from 'react-native-vector-icons/Ionicons';
import Card from '../../components/Card';
import Button from '../../components/Button';
import EmptyState from '../../components/EmptyState';
import LoadingSpinner from '../../components/LoadingSpinner';
import Toast from '../../components/Toast';
import { getMachines, deleteMachine } from '../../services/machineService';
import colors from '../../constants/colors';

const MachinesScreen = ({ navigation }) => {
  const [machines, setMachines] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [toast, setToast] = useState({ visible: false, message: '', type: 'info' });

  useEffect(() => {
    loadMachines();
  }, []);

  const loadMachines = async () => {
    try {
      setLoading(true);
      const data = await getMachines();
      setMachines(data);
    } catch (error) {
      setToast({
        visible: true,
        message: 'Failed to load machines',
        type: 'error',
      });
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const handleDelete = (machine) => {
    Alert.alert(
      'Delete Machine',
      `Are you sure you want to delete ${machine.name}?`,
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Delete',
          style: 'destructive',
          onPress: async () => {
            try {
              await deleteMachine(machine._id || machine.id);
              setMachines((prev) =>
                prev.filter((m) => (m._id || m.id) !== (machine._id || machine.id))
              );
              setToast({
                visible: true,
                message: 'Machine deleted successfully',
                type: 'success',
              });
            } catch (error) {
              setToast({
                visible: true,
                message: 'Failed to delete machine',
                type: 'error',
              });
            }
          },
        },
      ]
    );
  };

  const renderMachine = ({ item }) => (
    <Card style={styles.machineCard}>
      <View style={styles.machineHeader}>
        <View style={styles.machineIcon}>
          <Icon name="construct-outline" size={24} color={colors.primary} />
        </View>
        <View style={styles.machineInfo}>
          <Text style={styles.machineName}>{item.name}</Text>
          <Text style={styles.machineDetails}>
            {item.type} • {item.year || 'N/A'}
          </Text>
        </View>
        <TouchableOpacity
          onPress={() => handleDelete(item)}
          style={styles.deleteButton}
        >
          <Icon name="trash-outline" size={20} color={colors.error} />
        </TouchableOpacity>
      </View>
      <View style={styles.actions}>
        <Button
          title="Request Service"
          onPress={() =>
            navigation.navigate('CreateRequest', { machineId: item._id || item.id })
          }
          variant="primary"
          fullWidth={false}
          style={styles.serviceButton}
        />
        <Button
          title="Edit"
          onPress={() =>
            navigation.navigate('MachineForm', { machine: item })
          }
          variant="secondary"
          fullWidth={false}
          style={styles.editButton}
        />
      </View>
    </Card>
  );

  if (loading) {
    return <LoadingSpinner />;
  }

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>My Machines</Text>
        <TouchableOpacity
          onPress={() => navigation.navigate('MachineForm')}
          style={styles.addButton}
        >
          <Icon name="add-circle" size={32} color={colors.primary} />
        </TouchableOpacity>
      </View>

      {machines.length === 0 ? (
        <EmptyState
          icon="construct-outline"
          title="No Machines Yet"
          message="Add your first machine to start requesting services"
          actionLabel="Add Machine"
          onAction={() => navigation.navigate('MachineForm')}
        />
      ) : (
        <FlatList
          data={machines}
          keyExtractor={(item) => item._id || item.id}
          renderItem={renderMachine}
          contentContainerStyle={styles.list}
          refreshing={refreshing}
          onRefresh={() => {
            setRefreshing(true);
            loadMachines();
          }}
        />
      )}

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
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: wp('4%'),
    paddingVertical: wp('4%'),
    backgroundColor: colors.card,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  title: {
    fontSize: RFValue(20),
    fontWeight: '700',
    color: colors.textPrimary,
  },
  addButton: {},
  list: {
    padding: wp('4%'),
  },
  machineCard: {
    marginBottom: wp('4%'),
  },
  machineHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: wp('3%'),
  },
  machineIcon: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: `${colors.primary}20`,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: wp('3%'),
  },
  machineInfo: {
    flex: 1,
  },
  machineName: {
    fontSize: RFValue(16),
    fontWeight: '700',
    color: colors.textPrimary,
    marginBottom: wp('1%'),
  },
  machineDetails: {
    fontSize: RFValue(13),
    color: colors.textSecondary,
  },
  deleteButton: {
    padding: wp('2%'),
  },
  actions: {
    flexDirection: 'row',
    gap: wp('2%'),
  },
  serviceButton: {
    flex: 1,
    paddingHorizontal: wp('3%'),
  },
  editButton: {
    paddingHorizontal: wp('6%'),
  },
});

export default MachinesScreen;
