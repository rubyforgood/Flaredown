import React, { useState } from "react";
import { TouchableOpacity, StyleSheet, View } from "react-native";
import { Text } from "react-native-paper";

import { Theme } from "../Theme";
import BackButton from "../components/BackButton";
import Background from "../components/Background";
import Button from "../components/Button";
import Card from "../components/Card";
import Header from "../components/Header";
import Link from "../components/Link";
import TextInput from "../components/TextInput";

export default function LoginScreen({ navigation }) {
  const [email, setEmail] = useState({ value: "", error: "" });
  const [password, setPassword] = useState({ value: "", error: "" });

  const onLoginPressed = () => {
    navigation.navigate("Dashboard");
  };

  return (
    <Background>
      <BackButton goBack={navigation.goBack} />
      <Header>Welcome to Flaredown</Header>
      <Card>
        <TextInput
          label="Email"
          returnKeyType="next"
          value={email.value}
          onChangeText={(text) => setEmail({ value: text, error: "" })}
          error={!!email.error}
          errorText={email.error}
          autoCapitalize="none"
          autoCompleteType="email"
          textContentType="emailAddress"
          keyboardType="email-address"
        />
        <TextInput
          label="Password"
          returnKeyType="done"
          value={password.value}
          onChangeText={(text) => setPassword({ value: text, error: "" })}
          error={!!password.error}
          errorText={password.error}
          secureTextEntry
        />
        <View style={styles.forgotPassword}>
          <TouchableOpacity
            onPress={() => navigation.navigate("ResetPasswordScreen")}
          >
            <Text style={styles.forgot}>Forgot password</Text>
          </TouchableOpacity>
        </View>
        <Button mode="contained" onPress={onLoginPressed}>
          Log in
        </Button>
        <View style={styles.row}>
          <Text>Not a member yet? </Text>
          <Link onPress={() => navigation.replace("CreateAccountScreen")}>
            Sign up now
          </Link>
        </View>
      </Card>
    </Background>
  );
}

const styles = StyleSheet.create({
  forgotPassword: {
    width: "100%",
    alignItems: "flex-end",
    marginBottom: 10,
  },
  row: {
    flexDirection: "row",
    marginTop: 4,
  },
  forgot: {
    fontSize: 13,
    color: Theme.colors.secondary,
  },
});
