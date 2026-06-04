declare namespace fileAccess {
  interface ScanFileOptions {
    suffix?: Array<string>;
  }

  interface FileInfo {
    uri: string;
    fileName: string;
    size?: number;
    scanFile(options: ScanFileOptions): IteratorObject<FileInfo>;
  }

  interface RootInfo {
    uri: string;
  }

  interface FileAccessHelper {
    getFileInfoFromUri(uri: string): Promise<FileInfo>;
    getRoots(): Promise<IteratorObject<RootInfo>>;
  }

  function createFileAccessHelper(context: Object): FileAccessHelper;
}

export default fileAccess;
