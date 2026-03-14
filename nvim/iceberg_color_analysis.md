# VSCode Iceberg Theme - Color Relationship Analysis

## Core Color Palette

### Base Colors
- **Primary Background**: `#161821` - Main editor, sidebar, panel background
- **Secondary Background**: `#1e2132` - Hover states, gutter, widgets
- **Tertiary Background**: `#0e1015` - Status bar, tab inactive, title bar
- **Darkest Background**: `#0f1117` - Dropdown, input background, shadows

### Foreground Colors
- **Primary Text**: `#c6c8d1` - Main text, active elements
- **Secondary Text**: `#6b7089` - Comments, inactive elements, descriptions
- **Bright Text**: `#d2d4de` - Button hover, bright white terminal
- **Dimmed Text**: `#cdd1e6` - Active line numbers, focused elements

### Accent Colors
- **Blue (Primary Accent)**: `#84a0c6` - Keywords, links, progress bars
- **Cyan**: `#89b8c2` - Strings, modified files, info icons
- **Green**: `#b4be82` - Added content, success states, type annotations
- **Orange**: `#e2a478` - Warnings, important elements, section names
- **Purple**: `#a093c7` - Constants, attributes, values
- **Red**: `#e27878` - Errors, deleted content, breakpoints

## Color Relationship Patterns

### 1. Background Hierarchy
```
#0f1117 (Darkest) → #0e1015 (Dark) → #161821 (Primary) → #1e2132 (Light) → #242940 (Lightest)
```

**Usage Pattern**:
- **#161821**: Core backgrounds (editor, sidebar, panel, tabs active)
- **#1e2132**: Interactive/hover states (hover backgrounds, widgets, notifications)
- **#0e1015**: Status elements (status bar, inactive tabs, borders)
- **#0f1117**: Input/utility backgrounds (dropdowns, inputs, shadows)
- **#242940**: Subtle highlights (section headers, focus borders, rulers)

### 2. Foreground Hierarchy
```
#6b7089 (Dim) → #c6c8d1 (Normal) → #cdd1e6 (Bright) → #d2d4de (Brightest)
```

**Usage Pattern**:
- **#6b7089**: Secondary text (comments, inactive items, badges)
- **#c6c8d1**: Primary text (active text, foregrounds)
- **#cdd1e6**: Emphasized text (active line numbers, menu selection)
- **#d2d4de**: Highest emphasis (button hover, bright terminal white)

### 3. Semantic Color Distribution

#### Blue (#84a0c6) - Primary Accent
- **Primary Usage**: Keywords, storage, support, links
- **UI Elements**: Activity bar badge, buttons, progress bar
- **Interactive**: Input active border, text links
- **Terminal**: ANSI blue
- **Patterns**: Used for actionable/clickable elements and language keywords

#### Cyan (#89b8c2) - Information/Strings
- **Primary Usage**: Strings, debug info, modified resources
- **UI Elements**: Info icons, modified file indicators
- **Debug**: Info foreground, expression strings
- **Terminal**: ANSI cyan
- **Patterns**: Information display and string literals

#### Green (#b4be82) - Success/Addition
- **Primary Usage**: Added content, success states
- **UI Elements**: Git added resources, success icons
- **Editor**: Added lines in diff, gutter added background
- **Debug**: Start/restart icons, breakpoint stackframe
- **Terminal**: ANSI green
- **Patterns**: Positive states and additions

#### Orange (#e2a478) - Warnings/Important
- **Primary Usage**: Warnings, important elements
- **UI Elements**: Warning icons, editor warnings
- **Syntax**: Section names, method headings
- **Debug**: Warning console, breakpoint current stackframe
- **Terminal**: ANSI yellow
- **Patterns**: Attention-requiring elements

#### Purple (#a093c7) - Constants/Values
- **Primary Usage**: Constants, attributes, values
- **Syntax**: Constants, attributes, debug values
- **Terminal**: ANSI magenta
- **Patterns**: Data values and constant definitions

#### Red (#e27878) - Errors/Deletion
- **Primary Usage**: Errors, deleted content
- **UI Elements**: Error icons, deleted resources
- **Editor**: Error foreground, deleted lines
- **Debug**: Error console, breakpoint/stop icons
- **Terminal**: ANSI red
- **Patterns**: Error states and deletions

## Color Transformation Patterns

### Transparency Usage
1. **20% Opacity** (`20`): Subtle backgrounds (diff backgrounds, badge background)
2. **40% Opacity** (`40`): Medium emphasis (find highlight, word highlight)
3. **80% Opacity** (`80`): Strong emphasis (gutter backgrounds, overview ruler)
4. **4d/66 Opacity**: Selection backgrounds, hover states

### Brightness Variations
- **Brighter variants** (+10-15% brightness): Hover states, bright terminal colors
- **Darker variants** (-10-15% brightness): Subtle backgrounds, borders
- **Same color with transparency**: Background highlights, selection states

## UI Element Groupings

### Editor Group
- **Background**: `#161821` (primary)
- **Selection**: `#272c42` (unique darker blue)
- **Line Highlight**: `#1e2132` (secondary background)
- **Find Match**: `#e2a47880` (orange with transparency)

### Sidebar Group
- **Background**: `#161821` (matches editor)
- **Section Header**: `#242940` (subtle highlight)
- **Border**: `#0e1015` (dark border)

### Status/Navigation Group
- **Status Bar**: `#0e1015` (dark)
- **Tab Active**: `#161821` (matches editor)
- **Tab Inactive**: `#0e1015` (matches status bar)
- **Title Bar**: `#0e1015` (matches status bar)

### Input/Widget Group
- **Widget Background**: `#1e2132` (secondary)
- **Input Background**: `#0f1117` (darkest)
- **Dropdown**: `#0f1117` (matches input)

## Color Consistency Rules

1. **Background Consistency**: Editor, sidebar, panel, and active tabs share `#161821`
2. **Status Consistency**: Status bar, inactive tabs, and title bar share `#0e1015`
3. **Widget Consistency**: All widgets use `#1e2132` for backgrounds
4. **Semantic Consistency**: Each accent color maintains its semantic meaning across all contexts
5. **Hierarchy Consistency**: Darker backgrounds for less important elements, lighter for more important
6. **Transparency Consistency**: Same transparency levels used across similar interaction types

## Reusable Color Application Template

To apply Iceberg's color relationships to another theme:

1. **Establish 4-5 background tones** from darkest to lightest
2. **Define 3-4 foreground tones** from dim to bright  
3. **Assign 6 semantic accent colors** with consistent meanings
4. **Use transparency patterns** (20%, 40%, 80%) for layering
5. **Maintain semantic consistency** across all UI elements
6. **Follow hierarchy rules** for background/foreground relationships

This analysis shows Iceberg uses a systematic approach with clear color relationships, making it highly cohesive and adaptable to other themes.