import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import React from "react";
import { Provider } from "react-native-paper";

import { Theme } from "./app/Theme";
import CreateAccountScreen from "./app/screens/CreateAccountScreen";
import Dashboard from "./app/screens/Dashboard";
import LoginScreen from "./app/screens/LoginScreen";
import ResetPasswordScreen from "./app/screens/ResetPasswordScreen";

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <Provider theme={Theme}>
      <NavigationContainer>
        <Stack.Navigator
          initialRouteName="LoginScreen"
          screenOptions={{
            headerShown: false,
          }}
        >
          <Stack.Screen name="LoginScreen" component={LoginScreen} />
          <Stack.Screen
            name="CreateAccountScreen"
            component={CreateAccountScreen}
          />
          <Stack.Screen name="Dashboard" component={Dashboard} />
          <Stack.Screen
            name="ResetPasswordScreen"
            component={ResetPasswordScreen}
          />
        </Stack.Navigator>
      </NavigationContainer>
    </Provider>
  );
}
