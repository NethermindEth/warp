import { EventFragment, Interface, Result } from 'ethers/lib/utils';
import { argType, EventItem, join248bitChunks, splitInto248BitChunks } from '../utils/event';

export class WarpInterface extends Interface {
  decodeWarpEvent(fragment: EventFragment | string, warpEvent: EventItem): Result {
    warpEvent = join248bitChunks(warpEvent); // reverse 248 bit packing

    // Remove leading 0x from each element and join them
    const data = `0x${warpEvent.data.map((x) => x.slice(2)).join('')}`;

    const result = super.decodeEventLog(fragment, data, warpEvent.keys);
    return result;
  }

  encodeWarpEvent(fragment: EventFragment, values: argType[], order = 0): EventItem {
    const { data, topics }: { data: string; topics: string[] } = super.encodeEventLog(
      fragment,
      values,
    );

    const topicFlatHex = '0x' + topics.map((x) => x.slice(2).padStart(64, '0')).join('');
    const topicItems248: string[] = splitInto248BitChunks(topicFlatHex);
    const dataItems248: string[] = splitInto248BitChunks(data);

    return { order, keys: topicItems248, data: dataItems248 };
  }
}
