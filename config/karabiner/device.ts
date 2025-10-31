import { DeviceIdentifier } from "./libs/deps.ts";

function keyboard(
  identifier: Omit<DeviceIdentifier, "is_keyboard">,
): DeviceIdentifier {
  return { ...identifier, is_keyboard: true };
}

export const DEVICES = {
  apple: keyboard({
    vendor_id: 1452,
  }),
  macBook2018: keyboard({
    vendor_id: 1452,
    product_id: 634,
  }),
  progresTouchRetroTiny: keyboard({
    vendor_id: 11240,
    product_id: 4,
  }),
} as const;
