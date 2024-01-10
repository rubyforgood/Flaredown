import { View } from "react-native";

import Background from "../components/Background";
import Link from "../components/Link";

export default function Dashboard({ navigation }) {
  return (
    <Background>
      <View>
        <Link onPress={() => navigation.replace("LoginScreen")}>Log out</Link>
      </View>
    </Background>
  );
}
