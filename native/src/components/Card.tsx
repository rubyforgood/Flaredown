import React from "react";
import { StyleSheet } from "react-native";
import { Card } from "react-native-paper";

export default function Background({ children }) {
  return (
    <>
      <Card style={styles.card}>{children}</Card>
    </>
  );
}

const styles = StyleSheet.create({
  card: {
    padding: 30,
    width: "100%",
    maxWidth: 500,
  },
});
