import { DeviceIdentifier } from "karabinerts/deno.ts";

export const DEVICES = {
  apple: {
    is_keyboard: true,
  },
  progresTouchRetroTiny: {
    is_keyboard: true,
    vendor_id: 11240,
    product_id: 4,
  },
} as const satisfies Record<string, DeviceIdentifier>;
