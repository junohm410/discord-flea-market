"use client";

import Link from "next/link";
import { useEffect, useRef, useState } from "react";
import styled from "styled-components";

// TODO: 将来的に「ログイン時のみドロップダウンを表示し、未ログイン時はログイン導線を表示」に切替
const Header = () => {
  const [open, setOpen] = useState(false);
  const menuRef = useRef<HTMLDivElement | null>(null);;

  useEffect(() => {
    const onClick = (e: MouseEvent) => {
      if (!open) return;
      if (menuRef.current && !menuRef.current.contains(e.target as Node)) {
        setOpen(false);
      }
    };
    window.addEventListener("click", onClick);
    return () => window.removeEventListener("click", onClick);
  }, [open]);

  return (
    <Root>
      <Inner>
        <Logo href="/">Discord Flea Market</Logo>

        <Right>
          <User>
            <Avatar src="/favicon.ico" alt="avatar" />
            <Name>You</Name>
          </User>
          <Dropdown ref={menuRef}>
            <MenuButton type="button" onClick={() => setOpen((v) => !v)}>
              メニュー
            </MenuButton>
            {open && (
              <Menu>
                <MenuItem href="/items/listed" onClick={() => setOpen(false)}>
                  自分の商品一覧
                </MenuItem>
                <MenuItem
                  href="/items/requested"
                  onClick={() => setOpen(false)}
                >
                  購入希望一覧
                </MenuItem>
                <MenuDivider />
                <MenuAction
                  onClick={() => {
                    setOpen(false);
                    alert("ログアウト（未接続）。接続後に実装します。");
                  }}
                >
                  ログアウト
                </MenuAction>
                <MenuItem href="/withdraw" onClick={() => setOpen(false)}>
                  退会する
                </MenuItem>
              </Menu>
            )}
          </Dropdown>
        </Right>
      </Inner>
    </Root>
  );
};

const Root = styled.header`
  background: #ffffff;
  border-bottom: 1px solid #e5e7eb; /* gray-200 */
  box-shadow: 0 1px 0 rgba(0, 0, 0, 0.02);
`;

const Inner = styled.div`
  max-width: 1024px;
  margin: 0 auto;
  padding: 0 24px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
`;

const Logo = styled(Link)`
  font-size: 18px;
  font-weight: 800;
  color: #1d4ed8; /* primary-ish */
  text-decoration: none;
`;

const Right = styled.div`
  display: flex;
  align-items: center;
  gap: 12px;
`;

const User = styled.div`
  display: flex;
  align-items: center;
  gap: 8px;
`;

const Avatar = styled.img`
  width: 32px;
  height: 32px;
  border-radius: 999px;
  background: #f3f4f6;
`;

const Name = styled.span`
  font-size: 14px;
  color: #374151;
`;

const Dropdown = styled.div`
  position: relative;
`;

const MenuButton = styled.button`
  padding: 8px 12px;
  border-radius: 8px;
  background: #111827;
  color: #fff;
  font-weight: 700;
`;

const Menu = styled.div`
  position: absolute;
  right: 0;
  top: calc(100% + 8px);
  width: 224px;
  border-radius: 8px;
  background: #fff;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
  border: 1px solid #e5e7eb;
  padding: 8px 0;
  z-index: 50;
`;

const MenuItem = styled(Link)`
  display: block;
  padding: 10px 12px;
  color: #374151;
  text-decoration: none;
  &:hover {
    background: #f3f4f6;
  }
`;

const MenuAction = styled.button`
  display: block;
  width: 100%;
  text-align: left;
  padding: 10px 12px;
  color: #374151;
  background: transparent;
  border: none;
  cursor: pointer;
  font: inherit;
  &:hover {
    background: #f3f4f6;
  }
`;

const MenuDivider = styled.div`
  height: 1px;
  background: #e5e7eb;
  margin: 6px 0;
`;

export default Header;
