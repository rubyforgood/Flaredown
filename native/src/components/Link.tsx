import React from "react";
import { StyleSheet, Text, TouchableOpacity } from "react-native";


interface LinkProps {
  onPress: () => void;
  children: React.ReactNode;
}

export default function Link({ onPress, children }: LinkProps) {
  return (
    <TouchableOpacity onPress={onPress}>
      <Text style={styles.link}>{children}</Text>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  link: {
    fontWeight: "bold",
    // color: Theme.colors.primary,
  },
});
