import React from "react";
import { StyleSheet } from "react-native";
import { Button as TamaguiButton } from "tamagui";

export default function Button({ mode, style = {}, children, ...props }) {
  return (
    <TamaguiButton
      style={[
        styles.button,
        mode === "outlined", // && { backgroundColor: Theme.colors.surface },
        style,
      ]}
      // labelStyle={styles.text}
      // mode={mode}
      {...props}
    >
      {children}
    </TamaguiButton>
  );
}

const styles = StyleSheet.create({
  button: {
    width: "100%",
    marginVertical: 10,
    paddingVertical: 2,
  },
  text: {
    fontWeight: "bold",
    fontSize: 15,
    lineHeight: 26,
  },
});
