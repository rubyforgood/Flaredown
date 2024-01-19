import React, { useState } from "react";
import { View, StyleSheet } from "react-native";
import { Text } from "tamagui";

import BackButton from "../components/BackButton";
import Button from "../components/Button";
import Card from "../components/Card";
import Header from "../components/Header";
import Layout from "../components/Layout";
import Link from "../components/Link";
import TextInput from "../components/TextInput";
import { emailValidator } from "../helpers/emailValidator";
import { passwordValidator } from "../helpers/passwordValidator";
import { usernameValidator } from "../helpers/usernameValidator";

export default function CreateAccountScreen({ navigation }) {
  const [username, setUsername] = useState({ value: "", error: "" });
  const [email, setEmail] = useState({ value: "", error: "" });
  const [password, setPassword] = useState({ value: "", error: "" });

  const onSignUpPressed = () => {
    const usernameError = usernameValidator(username.value);
    const emailError = emailValidator(email.value);
    const passwordError = passwordValidator(password.value);
    if (emailError || passwordError || usernameError) {
      setUsername({ ...username, error: usernameError });
      setEmail({ ...email, error: emailError });
      setPassword({ ...password, error: passwordError });
      return;
    }
    navigation.reset({
      index: 0,
      routes: [{ name: "Dashboard" }],
    });
  };

  return (
    <Layout navigation={navigation}>
      <BackButton goBack={navigation.goBack} />
      <Header>Create account</Header>
      <Card>
        <TextInput
          label="Username"
          returnKeyType="next"
          value={username.value}
          onChangeText={(text) => setUsername({ value: text, error: "" })}
          error={!!username.error}
          errorText={username.error}
        />
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
        <Button
          mode="contained"
          onPress={onSignUpPressed}
          style={{ marginTop: 24 }}
        >
          Next
        </Button>
        <View style={styles.row}>
          <Text>Already a member? </Text>
          <Link onPress={() => navigation.replace("LoginScreen")}>Log in</Link>
        </View>
      </Card>
    </Layout>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: "row",
    marginTop: 4,
  },
});
