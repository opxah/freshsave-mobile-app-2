import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { useAuth } from '../contexts/AuthContext';

// Import your screens here
import LoginScreen from '../screens/auth/LoginScreen';
import SignUpScreen from '../screens/auth/SignUpScreen';
import CustomerHomeScreen from '../screens/customer/HomeScreen';
import ProductDetailScreen from '../screens/customer/ProductDetailScreen';
import StoreDetailScreen from '../screens/customer/StoreDetailScreen';
import BarcodeScannerScreen from '../screens/customer/BarcodeScannerScreen';
import FavoritesScreen from '../screens/customer/FavoritesScreen';
import SearchScreen from '../screens/customer/SearchScreen';
import CartScreen from '../screens/customer/CartScreen';
import AdminDashboardScreen from '../screens/admin/DashboardScreen';
import ProductManagementScreen from '../screens/admin/ProductManagementScreen';
import AddProductScreen from '../screens/admin/AddProductScreen';
import EditProductScreen from '../screens/admin/EditProductScreen';
import StoreProfileScreen from '../screens/admin/StoreProfileScreen';
import LoadingScreen from '../screens/LoadingScreen';

const Stack = createStackNavigator();
const Tab = createBottomTabNavigator();

const CustomerTabNavigator = () => (
  <Tab.Navigator
    screenOptions={{
      headerShown: false,
      tabBarPosition: 'bottom',
      tabBarStyle: {
        backgroundColor: 'white',
        borderTopWidth: 1,
        borderTopColor: '#e9ecef',
        paddingBottom: 0,
        paddingTop: 0,
        height: 80,
        elevation: 1,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: -1 },
        shadowOpacity: 0.03,
        shadowRadius: 1,
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
      },
      tabBarItemStyle: {
        borderRightWidth: 1,
        borderRightColor: '#e0e0e0',
        borderLeftWidth: 1,
        borderLeftColor: '#e0e0e0',
      },
      tabBarActiveTintColor: '#4CAF50',
      tabBarInactiveTintColor: '#666',
      tabBarLabelStyle: {
        fontSize: 12,
        fontWeight: '500',
        marginTop: 4,
      },
      tabBarIconStyle: {
        marginBottom: 4,
        marginTop: 8,
      },
    }}
  >
    <Tab.Screen 
      name="Home" 
      component={CustomerHomeScreen}
      options={{
        tabBarIcon: ({ color, size }) => (
          <MaterialIcons name="home" size={size} color={color} />
        ),
      }}
    />
    <Tab.Screen 
      name="Search" 
      component={SearchScreen}
      options={{
        tabBarIcon: ({ color, size }) => (
          <MaterialIcons name="search" size={size} color={color} />
        ),
      }}
    />
    <Tab.Screen 
      name="Favorites" 
      component={FavoritesScreen}
      options={{
        tabBarIcon: ({ color, size }) => (
          <MaterialIcons name="favorite" size={size} color={color} />
        ),
      }}
    />
    <Tab.Screen 
      name="Scan" 
      component={BarcodeScannerScreen}
      options={{
        tabBarIcon: ({ color, size }) => (
          <MaterialIcons name="qr-code-scanner" size={size} color={color} />
        ),
      }}
    />
    <Tab.Screen 
      name="Cart" 
      component={CartScreen}
      options={{
        tabBarIcon: ({ color, size }) => (
          <MaterialIcons name="shopping-cart" size={size} color={color} />
        ),
      }}
    />
  </Tab.Navigator>
);

const AdminTabNavigator = () => (
  <Tab.Navigator>
    <Tab.Screen name="Dashboard" component={AdminDashboardScreen} />
    <Tab.Screen name="Products" component={ProductManagementScreen} />
    <Tab.Screen name="Profile" component={StoreProfileScreen} />
  </Tab.Navigator>
);

const AppNavigator: React.FC = () => {
  const { user, isLoading } = useAuth();

  console.log('AppNavigator rendering:', { user: !!user, isLoading, userRole: user?.role });

  if (isLoading) {
    console.log('Showing LoadingScreen');
    return <LoadingScreen />;
  }

  console.log('Showing main navigation, user:', user);

  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {!user ? (
          <>
            <Stack.Screen name="Login" component={LoginScreen} />
            <Stack.Screen name="SignUp" component={SignUpScreen} />
          </>
        ) : (
          <>
            {user && user.role === 'customer' ? (
              <>
                <Stack.Screen name="CustomerTabs" component={CustomerTabNavigator} />
                <Stack.Screen name="ProductDetail" component={ProductDetailScreen} />
                <Stack.Screen name="StoreDetail" component={StoreDetailScreen} />
                <Stack.Screen name="BarcodeScanner" component={BarcodeScannerScreen} />
              </>
            ) : user && user.role === 'store_admin' ? (
              <>
                <Stack.Screen name="AdminTabs" component={AdminTabNavigator} />
                <Stack.Screen name="AddProduct" component={AddProductScreen} />
                <Stack.Screen name="EditProduct" component={EditProductScreen} />
              </>
            ) : null}
          </>
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
};

export default AppNavigator;
