import React from "react";
import { StyleSheet, View } from "react-native";

import { Theme } from "../Theme";

export default function Background({ children }) {
  return (
    <View style={styles.background}>
      <View style={styles.container}>{children}</View>
    </View>
  );
}

const styles = StyleSheet.create({
  background: {
    flex: 1,
    width: "100%",
    backgroundColor: Theme.colors.background,
  },
  container: {
    flex: 1,
    padding: 20,
    width: "100%",
    maxWidth: 500,
    alignSelf: "center",
    alignItems: "center",
    justifyContent: "center",
  },
});
