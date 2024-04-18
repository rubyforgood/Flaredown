import { render, screen } from "@testing-library/react-native";
import React from "react";

import App from "../src/App";

jest.useFakeTimers();

describe("<App />", () => {
  it("renders title", async () => {
    render(<App />);

    expect(screen.getByText("Welcome to Flaredown")).toBeDefined();
  });
});
