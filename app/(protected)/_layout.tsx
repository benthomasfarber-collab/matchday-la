import { useEffect } from "react";
import { Stack, router } from "expo-router";
import { useSupabase } from "@/hooks/useSupabase";

export default function ProtectedLayout() {
  const { supabase, session } = useSupabase();

  useEffect(() => {
    if (!session) return;
    supabase
      .from("profiles")
      .select("nationality")
      .eq("id", session.user.id)
      .single()
      .then(({ data }) => {
        if (!data?.nationality) {
          router.replace("/onboarding/nationality");
        }
      });
  }, [session?.user.id]);

  return (
    <Stack>
      <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
      <Stack.Screen
        name="onboarding/nationality"
        options={{ headerShown: false, gestureEnabled: false }}
      />
    </Stack>
  );
}
