/**
 * CLI utilities for parsing command line arguments
 */

export interface ParsedFlags {
  flags: Record<string, any>;
  args: string[];
}

/**
 * Parse command line arguments into flags and remaining args
 */
export function parseFlags(args: string[]): ParsedFlags {
  const flags: Record<string, any> = {};
  const remainingArgs: string[] = [];
  
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    
    if (arg.startsWith('--')) {
      // Long flag
      const flagName = arg.substring(2);
      if (flagName.includes('=')) {
        const [name, value] = flagName.split('=', 2);
        flags[name] = value;
      } else {
        // Check if next arg is a value
        if (i + 1 < args.length && !args[i + 1].startsWith('-')) {
          flags[flagName] = args[i + 1];
          i++; // Skip the value
        } else {
          flags[flagName] = true;
        }
      }
    } else if (arg.startsWith('-') && arg.length > 1) {
      // Short flag
      const flagName = arg.substring(1);
      if (i + 1 < args.length && !args[i + 1].startsWith('-')) {
        flags[flagName] = args[i + 1];
        i++; // Skip the value
      } else {
        flags[flagName] = true;
      }
    } else {
      // Regular argument
      remainingArgs.push(arg);
    }
  }
  
  return { flags, args: remainingArgs };
}
