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
  luma40: {
    is_keyboard: true,
    is_pointing_device: true,
    vendor_id: 14000,
    product_id: 12292,
  },
} as const satisfies Record<string, DeviceIdentifier>;
