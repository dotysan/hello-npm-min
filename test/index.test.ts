import {
  describe,
  expect,
  it,
  vi,
} from 'vitest';

import {
  hello,
} from '../src/index';

describe('hello', () => {
  it('should log "Hello, whirled!" to console', () => {
    const consoleSpy = vi.spyOn(console, 'log');
    hello();
    expect(consoleSpy).toHaveBeenCalledWith("Hello, whirled!");
    consoleSpy.mockRestore();
  });
});
