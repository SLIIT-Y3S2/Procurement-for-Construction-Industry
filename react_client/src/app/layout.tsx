import "./globals.css";
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import StyledComponentsRegistry from "@/lib/AntdRegistry";
import { App, ConfigProvider } from "antd";
import theme from "@/theme/themeConfig";
import PageLayout from "@/components/templates/PageLayout";
import AuthContextProvider from "@/context/auth/AuthContext";
import AuthenticationWrapper from "@/lib/AuthenticationWrapper";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "ProcureSync",
  description: "Generated by create next app",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        {" "}
        <StyledComponentsRegistry>
          <ConfigProvider theme={theme}>
            <App>
              <AuthContextProvider>
                <PageLayout>
                  <AuthenticationWrapper>
                    <main>{children}</main>
                  </AuthenticationWrapper>
                </PageLayout>
              </AuthContextProvider>{" "}
            </App>
          </ConfigProvider>
        </StyledComponentsRegistry>
      </body>
    </html>
  );
}
