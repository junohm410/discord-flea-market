"use client";

import { useMemo } from "react";
import Image from "next/image";
import styled from "styled-components";
import { Swiper, SwiperSlide } from "swiper/react";
import { Navigation, Pagination } from "swiper/modules";
import "swiper/css";
import "swiper/css/navigation";
import "swiper/css/pagination";

type ItemCarouselProps = {
  imageUrls: string[];
};

const ItemCarousel = ({ imageUrls }: ItemCarouselProps) => {
  const images = useMemo(() => imageUrls.filter(Boolean), [imageUrls]);
  const showPlaceholder = images.length === 0;

  return (
    <Root>
      {showPlaceholder ? (
        <Placeholder>画像なし</Placeholder>
      ) : (
        <Viewport>
          <Swiper
            modules={[Navigation, Pagination]}
            navigation
            pagination={{ clickable: true }}
            style={{ width: "100%", height: "100%" }}
          >
            {images.map((src) => (
              <SwiperSlide key={src}>
                <Slide>
                  <Image
                    src={src}
                    alt=""
                    fill
                    sizes="(max-width: 640px) 100vw, (max-width: 1024px) 600px, 720px"
                    style={{ objectFit: "cover" }}
                    priority
                  />
                </Slide>
              </SwiperSlide>
            ))}
          </Swiper>
        </Viewport>
      )}
    </Root>
  );
};

const Root = styled.div`
  position: relative;
  width: 100%;
  height: 100%;
`;

const Viewport = styled.div`
  position: relative;
  inset: 0;
  width: 100%;
  height: 100%;
`;

const Slide = styled.div`
  position: relative;
  width: 100%;
  height: 100%;
`;

const Placeholder = styled.div`
  display: grid;
  place-items: center;
  width: 100%;
  height: 100%;
  color: #6b7280;
  background: #f3f4f6;
`;

export default ItemCarousel;
