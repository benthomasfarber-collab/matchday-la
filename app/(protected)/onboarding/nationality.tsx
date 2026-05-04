import { useState, useMemo } from "react";
import {
  View,
  Text,
  TextInput,
  FlatList,
  TouchableOpacity,
  StyleSheet,
  SafeAreaView,
} from "react-native";
import { router } from "expo-router";
import { useSupabase } from "@/hooks/useSupabase";
import { COUNTRIES } from "@/constants/countries";

function flagEmoji(code: string): string {
  return code
    .toUpperCase()
    .replace(/./g, (c) =>
      String.fromCodePoint(0x1f1e6 + c.charCodeAt(0) - 65),
    );
}

export default function NationalityScreen() {
  const { supabase, session } = useSupabase();
  const [query, setQuery] = useState("");
  const [selected, setSelected] = useState<string | null>(null);
  const [saving, setSaving] = useState(false);

  const filtered = useMemo(
    () =>
      query.trim()
        ? COUNTRIES.filter((c) =>
            c.name.toLowerCase().includes(query.toLowerCase()),
          )
        : COUNTRIES,
    [query],
  );

  const onContinue = async () => {
    if (!selected || !session) return;
    setSaving(true);
    const { error } = await supabase
      .from("profiles")
      .update({ nationality: selected })
      .eq("id", session.user.id);
    setSaving(false);
    if (!error) {
      router.replace("/(protected)/(tabs)");
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Where are you from?</Text>
        <Text style={styles.subtitle}>Pick your nationality</Text>
      </View>
      <TextInput
        style={styles.search}
        placeholder="Search countries..."
        value={query}
        onChangeText={setQuery}
        autoCorrect={false}
        clearButtonMode="while-editing"
      />
      <FlatList
        data={filtered}
        keyExtractor={(item) => item.code}
        renderItem={({ item }) => (
          <TouchableOpacity
            style={[styles.row, selected === item.code && styles.rowSelected]}
            onPress={() => setSelected(item.code)}
            activeOpacity={0.7}
          >
            <Text style={styles.flag}>{flagEmoji(item.code)}</Text>
            <Text style={styles.name}>{item.name}</Text>
            {selected === item.code && (
              <Text style={styles.check}>✓</Text>
            )}
          </TouchableOpacity>
        )}
        keyboardShouldPersistTaps="handled"
        contentContainerStyle={styles.list}
      />
      <TouchableOpacity
        style={[styles.button, (!selected || saving) && styles.buttonDisabled]}
        onPress={onContinue}
        disabled={!selected || saving}
        activeOpacity={0.8}
      >
        <Text style={styles.buttonText}>
          {saving ? "Saving..." : "Continue"}
        </Text>
      </TouchableOpacity>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#fff" },
  header: { paddingHorizontal: 20, paddingTop: 24, paddingBottom: 12 },
  title: { fontSize: 28, fontWeight: "700", color: "#111" },
  subtitle: { fontSize: 16, color: "#666", marginTop: 4 },
  search: {
    marginHorizontal: 16,
    marginBottom: 8,
    paddingHorizontal: 14,
    paddingVertical: 12,
    borderRadius: 10,
    backgroundColor: "#f2f2f7",
    fontSize: 16,
  },
  list: { paddingBottom: 8 },
  row: {
    flexDirection: "row",
    alignItems: "center",
    paddingVertical: 13,
    paddingHorizontal: 20,
    gap: 14,
  },
  rowSelected: { backgroundColor: "#eff6ff" },
  flag: { fontSize: 26 },
  name: { flex: 1, fontSize: 17, color: "#111" },
  check: { fontSize: 17, color: "#2563eb", fontWeight: "700" },
  button: {
    margin: 16,
    paddingVertical: 16,
    borderRadius: 12,
    backgroundColor: "#2563eb",
    alignItems: "center",
  },
  buttonDisabled: { backgroundColor: "#93c5fd" },
  buttonText: { color: "#fff", fontSize: 17, fontWeight: "600" },
});
