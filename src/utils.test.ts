import { describe, it, expect } from 'vitest';
import { add, multiply } from './utils';

describe('add', () => {
  it('sums two positive numbers', () => {
    expect(add(2, 3)).toBe(5);
  });
  it('handles negatives', () => {
    expect(add(-1, -2)).toBe(-3);
  });
  it('handles zero', () => {
    expect(add(0, 0)).toBe(0);
  });
});

describe('multiply', () => {
  it('multiplies two positive numbers', () => {
    expect(multiply(2, 3)).toBe(6);
  });
  it('handles zero', () => {
    expect(multiply(5, 0)).toBe(0);
  });
});
