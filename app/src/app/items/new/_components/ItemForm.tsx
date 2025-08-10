"use client";

import { useMemo, useState } from "react";
import styled from "styled-components";

type FormState = {
  name: string;
  price: string;
  description: string;
  deadline: string;
  imageFile: File | null;
};

export default function ItemForm() {
  const [form, setForm] = useState<FormState>({
    name: "",
    price: "",
    description: "",
    deadline: "",
    imageFile: null,
  });

  const previewUrl = useMemo(() => {
    return form.imageFile ? URL.createObjectURL(form.imageFile) : null;
  }, [form.imageFile]);

  function update<K extends keyof FormState>(key: K, value: FormState[K]) {
    setForm((prev) => ({ ...prev, [key]: value }));
  }

  async function onSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    // TODO: Rails API 接続後はBFF経由でPOST（CSRF/Cookieを考慮）。今はモックで確認のみ
    // フォーム値は以下の通り
    console.log({ ...form, price: Number(form.price) || 0 });
    alert("まだ未接続です（モック）。API接続後に登録処理を実装します。");
  }

  return (
    <Main>
      <Heading>出品する</Heading>
      <Root onSubmit={onSubmit}>
        <Field>
          <Label>商品名</Label>
          <Input
            value={form.name}
            onChange={(e) => update("name", e.target.value)}
            required
          />
        </Field>

        <Field>
          <Label>価格（円）</Label>
          <Input
            type="number"
            inputMode="numeric"
            min={0}
            value={form.price}
            onChange={(e) => update("price", e.target.value)}
            required
          />
        </Field>

        <Field>
          <Label>説明</Label>
          <TextArea
            rows={4}
            value={form.description}
            onChange={(e) => update("description", e.target.value)}
          />
        </Field>

        <Field>
          <Label>購入希望の締切日</Label>
          <Input
            type="date"
            value={form.deadline}
            onChange={(e) => update("deadline", e.target.value)}
          />
        </Field>

        <Field>
          <Label>画像</Label>
          <Input
            type="file"
            accept="image/*"
            onChange={(e) => update("imageFile", e.target.files?.[0] ?? null)}
          />
          {previewUrl && <Preview src={previewUrl} alt="preview" />}
        </Field>

        <Actions>
          <Primary type="submit">この内容で出品する（モック）</Primary>
        </Actions>
      </Root>
    </Main>
  );
}

const Main = styled.main`
  padding: 24px;
`;

const Heading = styled.h1`
  margin: 0;
  font-size: 22px;
  font-weight: 800;
`;

const Root = styled.form`
  display: grid;
  gap: 16px;
  max-width: 720px;
`;

const Field = styled.div`
  display: grid;
  gap: 8px;
`;

const Label = styled.label`
  font-weight: 700;
`;

const Input = styled.input`
  padding: 10px 12px;
  border-radius: 8px;
  border: 1px solid rgba(0, 0, 0, 0.15);
  background: #fff;
`;

const TextArea = styled.textarea`
  padding: 10px 12px;
  border-radius: 8px;
  border: 1px solid rgba(0, 0, 0, 0.15);
  background: #fff;
`;

const Preview = styled.img`
  width: 240px;
  height: 180px;
  object-fit: cover;
  border-radius: 8px;
  background: #f3f4f6;
`;

const Actions = styled.div`
  display: flex;
  gap: 12px;
`;

const Primary = styled.button`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 10px 16px;
  border-radius: 8px;
  background: #111827;
  color: #fff;
  font-weight: 700;
`;
