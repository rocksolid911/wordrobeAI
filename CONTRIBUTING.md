# Contributing to Digital Wardrobe

Thank you for considering contributing to Digital Wardrobe! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- Clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable
- Device/platform information

### Suggesting Features

Feature requests are welcome! Please:
- Check if the feature has already been requested
- Provide clear use case and rationale
- Describe expected behavior
- Consider implementation complexity

### Code Contributions

1. **Fork the Repository**
   ```bash
   git clone https://github.com/your-username/digital-wardrobe.git
   cd digital-wardrobe
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Follow the existing code style
   - Write clear, commented code
   - Add tests if applicable
   - Update documentation

4. **Test Your Changes**
   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

   Follow [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation changes
   - `style:` Code style changes
   - `refactor:` Code refactoring
   - `test:` Test additions/changes
   - `chore:` Build/config changes

6. **Push and Create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```

   Then create a PR on GitHub with:
   - Clear title and description
   - Reference related issues
   - Screenshots for UI changes

## Development Guidelines

### Code Style

**Dart/Flutter:**
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` before committing
- Run `flutter analyze` and fix warnings

**JavaScript (Cloud Functions):**
- Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use ESLint for linting

### Project Structure

Keep code organized:
- Models in `lib/models/`
- Services in `lib/services/`
- Providers in `lib/providers/`
- Screens in `lib/screens/`
- Utilities in `lib/core/`

### Testing

- Write unit tests for business logic
- Write widget tests for UI components
- Test on both Android and iOS
- Test different screen sizes

### Documentation

- Comment complex logic
- Update README for major changes
- Add inline documentation for public APIs
- Update SETUP_GUIDE.md if setup process changes

## Pull Request Process

1. Ensure code passes all tests
2. Update documentation
3. Request review from maintainers
4. Address review feedback
5. Wait for approval and merge

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Help others learn

## Questions?

Open an issue or start a discussion on GitHub.

Thank you for contributing! 🎉
