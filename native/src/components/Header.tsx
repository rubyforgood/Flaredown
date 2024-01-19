import React from "react";
import { StyleSheet } from "react-native";
import { Text } from "tamagui";

// import { Theme } from "../Theme";

export default function Header(props) {
  return <Text style={styles.header} {...props} />;
}

const styles = StyleSheet.create({
  header: {
    fontSize: 21,
    // color: Theme.colors.primary,
    fontWeight: "bold",
    paddingVertical: 12,
  },
});
