import React, { useState } from "react";

import BackButton from "../components/BackButton";
import Background from "../components/Background";
import Button from "../components/Button";
import Card from "../components/Card";
import Header from "../components/Header";
import TextInput from "../components/TextInput";

export default function ResetPasswordScreen({ navigation }) {
  const [email, setEmail] = useState({ value: "", error: "" });

  const sendResetPasswordEmail = () => {
    // const emailError = emailValidator(email.value);
    // if (emailError) {
    //   setEmail({ ...email, error: emailError });
    //   return;
    // }
    navigation.navigate("LoginScreen");
  };

  return (
    <Background>
      <BackButton goBack={navigation.goBack} />
      <Header>Reset password</Header>
      <Card>
        <TextInput
          label="Email"
          returnKeyType="done"
          value={email.value}
          onChangeText={(text) => setEmail({ value: text, error: "" })}
          error={!!email.error}
          errorText={email.error}
          autoCapitalize="none"
          autoCompleteType="email"
          textContentType="emailAddress"
          keyboardType="email-address"
          description="You will receive an email with the reset link."
        />
        <Button
          mode="contained"
          onPress={sendResetPasswordEmail}
          style={{ marginTop: 16 }}
        >
          Continue
        </Button>
      </Card>
    </Background>
  );
}
