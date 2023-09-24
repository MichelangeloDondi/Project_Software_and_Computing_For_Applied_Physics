import os
import platform
import matplotlib.pyplot as plt
import matplotlib.patches as patches

# Define a dictionary of available electronic components and their names.
COMPONENTS = {
    'R': 'Resistor',
    'C': 'Capacitor',
    'L': 'Inductor'
}

def clear_screen():
    """Clear the terminal screen."""
    if platform.system() == "Windows":
        os.system('cls')
    else:
        os.system('clear')

def draw_component(ax, start, end, component):
    """Draw the specified electronic component between two points."""
    if not component:
        return

    mid_x = (start[0] + end[0]) / 2
    mid_y = (start[1] + end[1]) / 2

    # Define a circle radius based on the distance between start and end points
    circle_radius = min(abs(end[0] - start[0]), abs(end[1] - start[1])) / 8

    if component == 'R':
        # Draw a resistor as multiple zigzag lines inside the circle
        zigzag_x = [mid_x - circle_radius, mid_x - circle_radius/2, mid_x, mid_x + circle_radius/2, mid_x + circle_radius]
        zigzag_y = [mid_y - circle_radius/2, mid_y + circle_radius/2, mid_y - circle_radius/2, mid_y + circle_radius/2, mid_y - circle_radius/2]
        ax.plot(zigzag_x, zigzag_y, color="black")
    elif component == 'C':
        # Draw a capacitor as two parallel lines with a small gap in between
        ax.plot([mid_x - circle_radius/2, mid_x + circle_radius/2], [mid_y - circle_radius/4, mid_y - circle_radius/4], color="black")
        ax.plot([mid_x - circle_radius/2, mid_x + circle_radius/2], [mid_y + circle_radius/4, mid_y + circle_radius/4], color="black")
    elif component == 'L':
        # Draw an inductor as a series of loops
        loop_x = [mid_x - circle_radius, mid_x - circle_radius/2, mid_x, mid_x + circle_radius/2, mid_x + circle_radius]
        loop_y = [mid_y + circle_radius/2, mid_y - circle_radius/2, mid_y + circle_radius/2, mid_y - circle_radius/2, mid_y + circle_radius/2]
        ax.plot(loop_x, loop_y, color="black")

def get_point_input(prompt, point_names, default=None):
    """Get a point either by its coordinates or its name."""
    coord_str = input(prompt)
    if coord_str in point_names.values():
        return [k for k, v in point_names.items() if v == coord_str][0]
    elif not coord_str and default:
        return default
    else:
        x, y = map(float, coord_str.split(','))
        point = (x, y)
        if point not in point_names:
            point_names[point] = f"P_{len(point_names) + 1}"
        print(f"Assigned name for point: {point_names[point]}")
        return point

def get_branch(point_names, last_end=None):
    """Get the coordinates of the endpoints and the component for a branch."""
    try:
        start = get_point_input("Enter coordinates for the starting point of the branch as x,y (or its name, or just press Enter to use the last endpoint): ", point_names, default=last_end)
        end = get_point_input("Enter coordinates for the ending point of the branch as x,y (or its name): ", point_names)

        print("Available components: R (Resistor), C (Capacitor), L (Inductor). Press Enter for no component.")
        component = input(f"Enter component for branch between {point_names[start]} and {point_names[end]} (or just press Enter for no component): ").upper()
        while component not in COMPONENTS and component != "":
            print("Invalid component. Please choose from R, C, L or just press Enter for no component.")
            component = input(f"Enter component for branch between {point_names[start]} and {point_names[end]}: ").upper()

        return start, end, component if component else None
    except ValueError:
        print("Invalid input. Please enter coordinates as x,y or use a valid point name.")
        return None, None, None

def draw_branches():
    """Draw branches with their components until the user decides to stop."""
    fig, ax = plt.subplots(figsize=(10, 10))
    point_names = {}
    last_end = None
    while True:
        print("\nEnter coordinates for a new branch or type 'done' to finish:")
        start, end, component = get_branch(point_names, last_end=last_end)
        if not start or not end:
            continue
        ax.plot([start[0], end[0]], [start[1], end[1]], color='r', linewidth=2)
        draw_component(ax, start, end, component)
        
        # Label the points for clarity.
        ax.text(start[0], start[1], point_names[start], horizontalalignment='right', verticalalignment='bottom', fontsize=10, bbox=dict(facecolor='white', edgecolor='none', pad=0))
        ax.text(end[0], end[1], point_names[end], horizontalalignment='right', verticalalignment='bottom', fontsize=10, bbox=dict(facecolor='white', edgecolor='none', pad=0))
        
        last_end = end  # Update the last endpoint
        
        cont = input("Do you want to add another branch? (yes/no): ").lower()
        if cont != 'yes':
            break
        clear_screen()

    ax.set_aspect('equal')
    ax.autoscale_view()
    plt.grid(True, which='both', linestyle='--', linewidth=0.5)
    plt.show()

if __name__ == "__main__":
    draw_branches()