import { EventFragment, Interface, Result } from 'ethers/lib/utils';
import { argType, EventItem, join248bitChunks, splitInto248BitChunks } from '../utils/event';

export class WarpInterface extends Interface {
  decodeWarpEvent(fragment: EventFragment | string, warpEvent: EventItem): Result {
    // reverse 248 bit packing
    const data = join248bitChunks(warpEvent.data);
    const keys = join248bitChunks(warpEvent.keys);

    // Remove leading 0x from each element and join them
    const chunkedData = `0x${data.map((x) => x.slice(2)).join('')}`;

    return super.decodeEventLog(fragment, chunkedData, keys);
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
