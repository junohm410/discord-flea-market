"use client";

import { useMemo, useState } from "react";
import styled from "styled-components";

export type ItemUpsertValues = {
  name: string;
  price: number;
  description: string;
  deadline: string;
  imageFile: File | null;
};

export type ItemUpsertInitial = {
  name?: string;
  price?: number;
  description?: string;
  deadline?: string;
  imageUrl?: string;
};

export type ItemUpsertFormProps = {
  mode: "create" | "edit";
  heading?: string;
  submitLabel?: string;
  initial?: ItemUpsertInitial;
  onSubmit?: (values: ItemUpsertValues) => Promise<void> | void;
};

const ItemUpsertForm = ({
  mode,
  heading,
  submitLabel,
  initial,
  onSubmit,
}: ItemUpsertFormProps) => {
  const [name, setName] = useState(initial?.name ?? "");
  const [price, setPrice] = useState<string>(
    initial?.price != null ? String(initial.price) : ""
  );
  const [description, setDescription] = useState(initial?.description ?? "");
  const [deadline, setDeadline] = useState(initial?.deadline ?? "");
  const [imageFile, setImageFile] = useState<File | null>(null);

  const previewUrl = useMemo(() => {
    if (imageFile) return URL.createObjectURL(imageFile);
    return initial?.imageUrl ?? null;
  }, [imageFile, initial?.imageUrl]);

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const values: ItemUpsertValues = {
      name,
      price: Number(price) || 0,
      description,
      deadline,
      imageFile,
    };
    if (onSubmit) await onSubmit(values);
  }

  const resolvedHeading =
    heading ?? (mode === "edit" ? "商品を編集" : "出品する");
  const resolvedSubmit =
    submitLabel ?? (mode === "edit" ? "この内容で更新" : "この内容で出品する");

  return (
    <Main>
      <Heading>{resolvedHeading}</Heading>
      <Root onSubmit={handleSubmit}>
        <Field>
          <Label>商品名</Label>
          <Input
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
        </Field>

        <Field>
          <Label>価格（円）</Label>
          <Input
            type="number"
            inputMode="numeric"
            min={0}
            value={price}
            onChange={(e) => setPrice(e.target.value)}
            required
          />
        </Field>

        <Field>
          <Label>説明</Label>
          <TextArea
            rows={4}
            value={description}
            onChange={(e) => setDescription(e.target.value)}
          />
        </Field>

        <Field>
          <Label>購入希望の締切日</Label>
          <Input
            type="date"
            value={deadline}
            onChange={(e) => setDeadline(e.target.value)}
          />
        </Field>

        <Field>
          <Label>画像</Label>
          <Input
            type="file"
            accept="image/*"
            onChange={(e) => setImageFile(e.target.files?.[0] ?? null)}
          />
          {previewUrl && <Preview src={previewUrl} alt="preview" />}
        </Field>

        <Actions>
          <Primary type="submit" onClick={() => console.log("submit click")}>
            {resolvedSubmit}（モック）
          </Primary>
        </Actions>
      </Root>
    </Main>
  );
};

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

export default ItemUpsertForm;
