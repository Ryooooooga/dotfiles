import { DeviceIdentifier } from "../libs/deps.ts";

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
  realforceR2: keyboard({
    vendor_id: 2131,
    product_id: 328,
  }),
  akl680: keyboard({
    vendor_id: 1452,
    product_id: 591,
  }),
  mk23: (is_pointing_device: boolean = true) =>
    keyboard({
      is_pointing_device: is_pointing_device || undefined,
      vendor_id: 41606,
      product_id: 41888,
    }),
  mk24: (is_pointing_device: boolean = true) =>
    keyboard({
      is_pointing_device: is_pointing_device || undefined,
      vendor_id: 41606,
      product_id: 44451,
    }),
} as const;
