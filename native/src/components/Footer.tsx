import React from "react";
import { View, Text, StyleSheet, Linking } from "react-native";

import Button from "./Button";
import Link from "./Link";

const currentYear = new Date().getFullYear();

export default function Footer({ navigation }) {
  const handleHelpPress = () => {
    Linking.openURL(`mailto:contact@flaredown.com`);
  };

  const handleTosPress = () => {
    navigation.navigate("ToS");
  };

  const handlePrivacyPress = () => {
    navigation.navigate("PrivacyPolicy");
  };

  return (
    <View style={styles.footer}>
      <Button onPress={handleHelpPress} mode="outlined">
        Help & Feedback
      </Button>
      <View style={styles.links}>
        <Link onPress={handleTosPress}>Terms of Service</Link>
        <Link onPress={handlePrivacyPress}>Privacy Policy</Link>
      </View>
      <Text>Flaredown © {currentYear}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  footer: {
    marginTop: 10,
    gap: 10,
    alignItems: "center",
  },
  links: {
    flexDirection: "row",
    gap: 10,
    display: "flex",
  },
});
