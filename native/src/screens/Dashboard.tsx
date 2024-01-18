import React from "react";
import { View } from "react-native";

import Layout from "../components/Layout";
import Link from "../components/Link";

export default function Dashboard({ navigation }) {
  return (
    <Layout navigation={navigation}>
      <View>
        <Link onPress={() => navigation.replace("LoginScreen")}>Log out</Link>
      </View>
    </Layout>
  );
}
